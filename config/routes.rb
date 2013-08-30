plugin = Refinery::Plugins['inquiries']
if plugin
  if plugin.page.present?
    plugin.page.reload

    Refinery::Core::Engine.routes.draw do
      namespace :inquiries, :path => '' do
        if Refinery::Pages.marketable_urls
          Globalize.with_locales plugin.page.translated_locales do
            get "#{plugin.page.nested_path}", :to => 'inquiries#new'
            post "#{plugin.page.nested_path}", :to => 'inquiries#create'
          end
        else
          resources :inquiries, :only => [:new, :create]
        end
      end
    end
  end

  Refinery::Core::Engine.routes.draw do
    namespace :admin, :path => Refinery::Core.backend_route do
      namespace :inquiries, :path => '' do
        resources :inquiries, :only => [:index, :show, :destroy] do
          collection do
            get :spam
            get :archived

            resources :settings, :only => [:edit, :update] do
              match :confirmation_email, :via => [:get, :patch], :on => :collection
            end
          end

          get :toggle_spam, :on => :member
          get :toggle_archive, :on => :member
        end
      end
    end
  end
end
