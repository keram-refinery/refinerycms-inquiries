module Refinery
  module Inquiries
    class InquiriesController < ::ApplicationController

      before_filter :find_page
      before_filter :redirect_unless_path_match, :only => [:new]

      def new
        @inquiry = ::Refinery::Inquiries::Inquiry.new
      end

      def create
        @inquiry = ::Refinery::Inquiries::Inquiry.new(inquiry_params)

        if @inquiry.save
          if @inquiry.ham?
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

          redirect_to refinery.url_for((thank_you_page || page).url)
        else
          render :new
        end
      end

      protected

      def find_page(fallback_to_404 = true)
        @page ||= Refinery::Page.with_globalize.find_by_plugin_page_id 'refinery_inquiries'
        @page || (error_404 if fallback_to_404)
      end

      alias_method :page, :find_page

      def thank_you_page
        @thank_you_page ||= Refinery::Page.with_globalize.find_by_plugin_page_id 'refinery_inquiries_thank_you'
      end

      def redirect_unless_path_match
        redirect_to refinery.url_for(page.url) and return unless request.fullpath.match(page.nested_path)
      end

      def new_respond status=:ok
        @form_holder_config = {
            :id => 'inquiry-form-holder',
            :class => 'inquiries',
            :append_to => '#body .inner'
        }

        respond_to do |format|
          if params[:form_holder_id].present? && params[:form_holder_id] =~ /\A[a-zA-Z]+[\w\-]{,32}\z/
            @form_holder_config[:id] = params[:form_holder_id]
          end

          format.html do
            render action: 'new'
          end

          format.json do
            json_response status, {
              :errors => @inquiry.errors,
              :html => { @form_holder_config[:id] => render_html_to_json_string('form') }}
          end
        end
      end

      def inquiry_params
        params.require(:inquiry).permit(:name, :email, :phone, :message)
      end
    end
  end
end
