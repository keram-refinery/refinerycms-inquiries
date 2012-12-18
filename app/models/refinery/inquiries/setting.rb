module Refinery
  module Inquiries
    class Setting

      class << self
        def confirmation_body(locale=Refinery::I18n.default_frontend_locale)
          Refinery::Setting.find_by(name: "inquiry_confirmation_body_#{locale}".to_sym, scoping: 'inquiries').value
        end

        def confirmation_body=(value)
          value.first.keys.each do |locale|
            Refinery::Setting.set("inquiry_confirmation_body_#{locale}".to_sym, {
                                    :value => value.first[locale.to_sym],
                                    :destroyable => false,
                                    :scoping => 'inquiries'
                                  })
          end
        end

        def confirmation_subject(locale=Refinery::I18n.default_frontend_locale)
          Refinery::Setting.find_by(name: "inquiry_confirmation_subject_#{locale}", scoping: 'inquiries').value
        end

        def confirmation_subject=(value)
          value.first.keys.each do |locale|
            Refinery::Setting.set("inquiry_confirmation_subject_#{locale}".to_sym, {
                                    :value => value.first[locale.to_sym],
                                    :destroyable => false,
                                    :scoping => 'inquiries'
                                  })
          end
        end

        def notification_subject(locale=Refinery::I18n.default_locale)
          Refinery::Setting.find_by(name: "inquiry_confirmation_subject_#{locale}", scoping: 'inquiries').value
        end

        # todo send localized notifications for user
        def notification_recipients
          Refinery::Setting.find_or_set(:inquiry_notification_recipients,
                                        ((Refinery::Role[:refinery].users.first.email rescue nil) if defined?(Refinery::Role)).to_s,
                                        :scoping => 'inquiries')
        end

        def send_confirmation?
          Refinery::Setting.find_by(name: :inquiry_send_confirmation,  scoping: 'inquiries')
        end
      end
    end
  end
end
