module Refinery
  module Admin
    module Inquiries
      module InquiriesHelper

        def fresh_count
          Refinery::Inquiries::Inquiry.where(archived: false, spam: false).count
        end

        def spam_count
          Refinery::Inquiries::Inquiry.spam.count
        end

        def archived_count
          Refinery::Inquiries::Inquiry.where(archived: true).count
        end

        def list_type
          if @inquiry.present?
            if @inquiry.spam? || @inquiry.archived?
              'index'
            else
              action_name.gsub('toggle_', '')
            end
          else
            action_name
          end
        end
      end
    end
  end
end
