module Refinery
  module Admin
    module Inquiries
      class SettingsController < Refinery::AdminController

        helper Refinery::Admin::SettingsHelper

        before_action :find_setting, :restrict_access, only: [:edit, :update]

        def update
          if @setting.update(setting_params)
            flash[:notice] = t('refinery.crudify.updated', kind: 'Setting', what: @setting.name.titleize)

            redirect_back_or_default(refinery.admin_inquiries_inquiries_path)
          else
            render :edit
          end
        end

        def confirmation_email
          if params.keys.include?('subject') && params.keys.include?('body')
            save_subject_for_confirmation
            save_message_for_confirmation
            flash[:notice] = t('refinery.crudify.updated', kind: 'Inquiry', what: 'confirmation email')
          end
        end

      protected

        def find_setting
          @setting = Refinery::Setting.find_by(slug: params[:id], scoping: 'inquiries') if params[:id].friendly_id?
          @setting = Refinery::Setting.find_by(id: params[:id]) unless @setting || params[:id].friendly_id?

          @setting || error_404
        end

        def restrict_access
          if @setting.restricted? && !current_refinery_user.has_role?(:superuser)
            error_403
          end
        end

        def save_subject_for_confirmation
          Refinery::Inquiries::Setting.confirmation_subject = params[:subject]
        end

        def save_message_for_confirmation
          Refinery::Inquiries::Setting.confirmation_body = params[:body]
        end

        def setting_params
          params.require(:setting).permit(:value, :restricted)
        end

      end
    end
  end
end
