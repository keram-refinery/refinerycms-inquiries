plugin = Refinery::Plugins['refinery_inquiries']

::Refinery::User.all.each do |user|
  if user.plugins.where(name: plugin.name).blank?
    user.plugins.create(name: plugin.name, position: 100)
  end
end if defined?(::Refinery::User)

pages = {
  contact: {
    title: 'Contact',
    deletable: false,
    plugin_page_id: plugin.name
  },
  thank_you: {
    title: 'Thank You',
    parent: :contact,
    deletable: false,
    show_in_menu: false,
    plugin_page_id: "#{plugin.name}_thank_you"
  },
  privacy_policy: {
    title: 'Privacy Policy',
    deletable: true,
    show_in_menu: false,
    plugin_page_id: "#{plugin.name}_privacy_policy"
  }
}

Refinery::Pages.seed(plugin, pages)

# todo move to locales
inquiry_confirmation_body = "Thank you for your inquiry %name%,\n\n" +
                            "This email is a receipt to confirm we have received your inquiry " +
                            "and we'll be in touch shortly.\n\nThanks."
inquiry_confirmation_subject = 'Thank you for your inquiry'
inquiry_notification_subject = 'New inquiry from your website'

Globalize.with_locales Refinery::I18n.frontend_locales do |locale|
  Refinery::Setting.find_or_set("inquiry_confirmation_subject_#{locale}",
                              inquiry_confirmation_subject,
                              destroyable: false,
                              scoping: 'inquiries')

  Refinery::Setting.find_or_set("inquiry_confirmation_body_#{locale}",
                              inquiry_confirmation_body,
                              destroyable: false,
                              scoping: 'inquiries')
end

Globalize.with_locale Refinery::I18n.default_locale do |locale|
  Refinery::Setting.find_or_set("inquiry_notification_subject_#{locale}",
                              inquiry_notification_subject,
                              destroyable: false,
                              scoping: 'inquiries')
end

Refinery::Setting.find_or_set(:inquiry_notification_recipients,
                            ((Refinery::Role[:refinery].users.first.email rescue nil) if defined?(Refinery::Role)).to_s,
                            scoping: 'inquiries',
                            destroyable: false)

Refinery::Setting.find_or_set(:inquiry_send_confirmation,
                            true,
                            scoping: 'inquiries',
                            destroyable: false)
