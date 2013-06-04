SNGTRKR::Application.routes.draw do

  resources :reports

  root :to => "pages#home"

  get 'pages/:action' => 'pages#:action'

  #get '/:id' => "shortener/shortened_urls#show"

  if Rails.env.development?
    mount RailsEmailPreview::Engine, :at => 'mail_preview' # You can choose any URL here
  end

  constraints lambda { |request| request.env["warden"].authenticate? and User.find(request.env["warden"].user).roles.first.name == "Admin" } do
    require 'sidekiq/web'
    namespace :admin do
      root :to => "admin#overview"
      mount RailsAdmin::Engine => '/rails', :as => 'rails_admin'
      mount Sidekiq::Web => '/sidekiq'
      get '/:action' => "admin#:action"
    end
  end

  get '/about' => "pages#about"
  get '/terms' => "pages#terms"
  get '/privacy' => "pages#privacy"
  get '/release_magic/:store/:url' => "releases#magic"

  devise_for :users, :controllers => {
      :registrations => "users_controller/registrations",
      :omniauth_callbacks => "users_controller/omniauth_callbacks",
      :sessions => "users_controller/sessions"
  }
  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  get '/tl' => "users#timeline"

  resources :users, :except => [:index, :edit, :update] do
    member do
      get 'public'
      get 'destroy_confirm'
      post 'destroy_with_reason'
      get 'friends'
      get 'recommend'
      get 'timeline/:page' => 'timeline#index'
    end
    collection do
      get 'me', :action => 'self'
      get 'me/timeline/:page' => 'timeline#index'
    end
    resources :manages
  end

  get 'search' => 'search#omni'

  resources :artists, :except => [:index] do
    collection do
      get 'fb_import/:fb_id', :action => 'fb_import'
      get 'first_suggestions'
      get 'unfollow' => 'follows#batch_destroy'
    end
    resources :releases
    get 'scrape_confirm' => 'artists#scrape_confirm'
    resources :follows, :except => [:destroy, :edit]
    get 'unfollow' => 'follows#user_destroy'
    #resources :suggests, :except => [:destroy,:edit]
    get 'unsuggest' => 'suggests#destroy'
  end

  # Allows us to have intuitive /artist/1/follow URLs that actually deal with the
  # user controller
  # resources :artists, :controller => 'users'

end
