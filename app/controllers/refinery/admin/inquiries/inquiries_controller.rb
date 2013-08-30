module Refinery
  module Admin
    module Inquiries
      class InquiriesController < ::Refinery::AdminController

        include InquiriesHelper

        crudify :'refinery/inquiries/inquiry',
                title_attribute: 'email'

        before_action :find_all_in_index, only: [:index]
        before_action :find_all_in_archived, only: [:archived]
        before_action :find_all_in_spam, only: [:spam]
        before_action :find_inquiry, only: [:show, :destroy, :toggle_archive, :toggle_spam]
        before_action :paginate_inquiries, only: [:index, :archived, :spam]

        def spam
          render action: :index
        end

        def archived
          render action: :index
        end

        def toggle_archive
          @inquiry.toggle!(:archived)
          redirect_to(@inquiry.archived? ? refinery.admin_inquiries_inquiries_path : refinery.archived_admin_inquiries_inquiries_path)
        end

        def toggle_spam
          @inquiry.toggle!(:spam)
          redirect_to(@inquiry.spam? ? refinery.admin_inquiries_inquiries_path : refinery.spam_admin_inquiries_inquiries_path)
        end

        protected

        def find_all_in_index
          @inquiries = Refinery::Inquiries::Inquiry.fresh.ham
        end

        def find_all_in_archived
          @inquiries = Refinery::Inquiries::Inquiry.archived
        end

        def find_all_in_spam
          @inquiries = Refinery::Inquiries::Inquiry.spam
        end

        def paginate_inquiries
          @inquiries = @inquiries.page(paginate_page)
        end

      end
    end
  end
end
