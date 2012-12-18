plugin = Refinery::Plugins['refinery_inquiries']

::Refinery::User.all.each do |user|
  if user.plugins.where(name: plugin.name).blank?
    user.plugins.create(name: plugin.name, position: 100)
  end
end if defined?(::Refinery::User)

if defined?(::Refinery::Page)
  contact_us_page = plugin.page
  # line Refinery::Page.find_by.. is required for proper running rake db:reset command
  unless contact_us_page.present? && Refinery::Page.find_by(id: contact_us_page.id).present?
    contact_us_page = ::Refinery::Page.create({
      title: 'Contact',
      show_in_menu: true,
      plugin_page_id: plugin.name,
      deletable: false
    })

    contact_us_page.parts.create({
      title: 'Body',
      body: '<p>Get in touch with us. Just use the form below and we\'ll get back to you as soon as we can.</p>',
      position: 0
    })

    contact_us_page.parts.create({
      title: 'Side Body',
      body: '',
      position: 1
    })
  end

  unless plugin.thank_you_page.present?
    thank_you_page = contact_us_page.children.create({
      title: 'Thank You',
      show_in_menu: false,
      plugin_page_id: "#{plugin.name}_thank_you",
      deletable: false
    })

    thank_you_page.parts.create({
      title: 'Body',
      body: '<p>We\'ve received your inquiry and will get back to you with a response shortly.</p>' +
                '<p><a href="/">Return to the home page</a></p>',
      position: 0
    })
  end

  unless plugin.privacy_policy_page.present?
    privacy_policy_page = contact_us_page.children.create({
      title: 'Privacy Policy',
      plugin_page_id: "#{plugin.name}_privacy_policy",
      deletable: true,
      show_in_menu: false
    })

    privacy_policy_page.parts.create({
      title: 'Body',
      body: '<p>We respect your privacy. We do not market, rent or sell our email list to any outside parties.</p>' +
            '<p>We need your e-mail address so that we can ensure that the people using our forms are bona fide. ' +
            'It also allows us to send you e-mail newsletters and other communications, if you opt-in. ' +
            'Your postal address is required in order to send you information and pricing, if you request it.</p>' +
            '<p>Please call us at 123 456 7890 if you have any questions or concerns.</p>',
      position: 0
    })
  end
end

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
