module Refinery
  module Admin
    module Inquiries
      class InquiriesController < ::Refinery::AdminController

        include InquiriesHelper

        crudify :'refinery/inquiries/inquiry',
                title_attribute: 'email'

        helper_method :group_by_date

        before_action :find_all_in_index, only: [:index]
        before_action :find_all_in_archived, only: [:archived]
        before_action :find_all_in_spam, only: [:spam]
        before_action :paginate_inquiries, only: [:index, :archived, :spam]

        def spam
          render action: :index
        end

        def archived
          render action: :index
        end

        def toggle_archive
          find_inquiry
          @inquiry.toggle!(:archived)

          if request.xhr?
            send(:"find_all_in_#{list_type}")
            paginate_inquiries

            render json: json_response(html: {
              records: render_html_to_json_string('records'),
              fresh_count: (fresh_count > 0 ? "(#{fresh_count})" : ''),
              archived_count: (archived_count > 0 ? "(#{archived_count})" : '')
            })
          else
            redirect_to @inquiry.archived? ? refinery.admin_inquiries_inquiries_path : refinery.archived_admin_inquiries_inquiries_path
          end
        end

        def toggle_spam
          find_inquiry
          @inquiry.toggle!(:spam)

          if request.xhr?
            send(:"find_all_in_#{list_type}")
            paginate_inquiries

            render json: json_response(html: {
              records: render_html_to_json_string('records'),
              spam_count: (spam_count > 0 ? "(#{spam_count})" : ''),
              fresh_count: (fresh_count > 0 ? "(#{fresh_count})" : '')
            })
          else
            redirect_to @inquiry.spam? ? refinery.admin_inquiries_inquiries_path : refinery.spam_admin_inquiries_inquiries_path
          end
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
          @inquiries = @inquiries.page(params[:page])
        end

      end
    end
  end
end
