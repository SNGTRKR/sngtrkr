SNGTRKR::Application.routes.draw do

  match 'sitemap.xml' => 'sitemaps#sitemap'

  root :to => "pages#home"
  
  match 'pages/:action' => 'pages#:action'

  constraints lambda{|request| request.env["warden"].authenticate? and User.find(request.env["warden"].user).roles.first.name == "Admin" } do
    require 'sidekiq/web'
    namespace :admin do
      root :to => "admin#overview"
      mount RailsAdmin::Engine => '/rails', :as => 'rails_admin'
      mount Sidekiq::Web => '/sidekiq'  
      match '/:action' => "admin#:action"
    end
  end
  
  match '/about' => "Pages#about"
  match '/terms' => "Pages#terms"
  match '/team' => "Pages#team"
  match '/privacy' => "Pages#privacy"
  match '/help' => "Pages#help"
  match '/release_magic/:store/:url' => "Releases#magic"
  match '/intro' => "Pages#intro"

  mount UserMailer::Preview => 'mailer'

  devise_for :users, :controllers => { :registrations => "users_controller/registrations",
    :omniauth_callbacks => "users_controller/omniauth_callbacks",
    :sessions => "users_controller/sessions"}
  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
  
  match '/tl' => "Users#timeline"
  
  resources :users, :except =>[:index] do
    member do
      match 'public'
      get 'unmanage'
      get 'destroy_confirm'
      post 'destroy_with_reason'
      get 'manage_confirm'
      get 'managing'
      get 'friends'
      get 'recommend'
      get 'timeline/:page' => 'Timeline#index'
    end
    collection do
      match 'me', :action => 'self'
      match 'me/timeline/:page' => 'Timeline#index'
    end
    resources :manages
  end
  
  match '/artists/search' => "Artists#search"
  resources :artists do
    collection do
      match 'import/:fb_id', :action => 'import'
      match 'preview'
      get 'first_suggestions'
      match 'unfollow' => 'Follows#batch_destroy'
    end
    resources :releases do 
      member do 
        post 'rate'
        get 'previews'
      end
    end
    resources :manages
    match 'scrape_confirm' => 'Artists#scrape_confirm'
    resources :follows, :except => [:destroy,:edit]
    match 'unfollow' => 'Follows#user_destroy'
    #resources :suggests, :except => [:destroy,:edit]
    match 'unsuggest' => 'Suggests#destroy'
  end
  resources :releases do 
    member do 
      post 'rate'
    end
  end

  # Allows us to have intuitive /artist/1/follow URLs that actually deal with the
  # user controller
  resources :artists, :controller => 'users' do
    member do
      get 'manage'
      get 'unmanage'
    end
  end

  resources :feedbacks

end
