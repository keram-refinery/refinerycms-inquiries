module Refinery
  module Inquiries
    class Engine < Rails::Engine
      extend Refinery::Engine

      isolate_namespace Refinery::Inquiries

      initializer 'init plugin' do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'inquiries'
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.admin_inquiries_inquiries_path }
          plugin.activity = {
            :class_name => :'refinery/inquiries/inquiry',
            :title => 'name',
            :url_prefix => nil,
            :url => 'refinery.admin_inquiries_inquiry_path'
          }

        end
      end

      initializer 'refinery.pages append marketable routes', :after => :set_routes_reloader_hook do
        Rails.application.routes_reloader.reload!
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Inquiries)
      end

    end
  end
end
