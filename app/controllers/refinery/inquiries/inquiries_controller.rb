module Refinery
  module Inquiries
    class InquiriesController < ::Refinery::PagesController
      helper Refinery::Core::Engine.helpers

      before_action :find_page
      before_action :redirect_unless_path_match, only: [:new]

      def new
        @inquiry = ::Refinery::Inquiries::Inquiry.new
      end

      def create
        @inquiry = ::Refinery::Inquiries::Inquiry.new(inquiry_params)

        if @inquiry.save
          if @inquiry.ham? || Refinery::Inquiries.send_notifications_for_inquiries_marked_as_spam
            begin
              ::Refinery::Inquiries::InquiryMailer.notification(@inquiry, request).deliver
            rescue
              logger.warn "There was an error delivering an inquiry notification.\n#{$!}\n"
            end

            begin
              ::Refinery::Inquiries::InquiryMailer.confirmation(@inquiry, request).deliver
            rescue
              logger.warn "There was an error delivering an inquiry confirmation:\n#{$!}\n"
            end if ::Refinery::Inquiries::Setting.send_confirmation?
          end

          redirect_to refinery.url_for((thank_you_page || page).url), status: :see_other
        else
          render :new
        end
      end

      protected

      def find_page(fallback_to_404 = true)
        @page ||= Refinery::Page.with_globalize.find_by_plugin_page_id 'inquiries'
        @page || (error_404 if fallback_to_404)
      end

      alias_method :page, :find_page

      def thank_you_page
        @thank_you_page ||= Refinery::Page.with_globalize.find_by_plugin_page_id 'inquiries_thank_you'
      end

      def redirect_unless_path_match
        redirect_to refinery.url_for(page.url) and return unless request.fullpath.match(page.nested_path)
      end

      def inquiry_params
        params.require(:inquiry).permit(:name, :email, :phone, :message)
      end
    end
  end
end
