require 'sidekiq/web'
SNGTRKR::Application.routes.draw do

  resources :reports

  root :to => "pages#home"

  get 'pages/:action' => 'pages#:action'

  #get '/:id' => "shortener/shortened_urls#show"
  get '/timeline_releases/populate' => 'timeline#populate_user_timeline'

  if Global.custom.mail_view["enabled"]
    mount RailsEmailPreview::Engine, at: 'emails'
  end

  namespace :admin do
    constraints lambda { |request| request.env["warden"].authenticate? and User.find(request.env["warden"].user).roles.first.name == "Admin" } do
      root :to => "admin#overview"
      mount Sidekiq::Web => '/sidekiq'
      get '/:action' => "admin#:action"
    end
  end
  # Setup explore pages
  get '/explore' => "pages#explore"
  get '/explore/release/:page' => 'pages#explore_release'
  get '/explore/artist/:page' => 'pages#explore_artist'

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

  get '/timeline' => "users#timeline"

  resources :users, :except => [:index, :edit, :update] do
    member do
      get 'public'
      post 'destroy_with_reason'
      get 'friends'
      # get 'timeline/:page' => 'timeline#index'
    end
    collection do
      get 'me', :action => 'self'
      # get 'me/timeline/:page' => 'timeline#index'
    end
    resources :manages
  end

  get 'search' => 'search#omni'

  resources :artists, :except => [:index] do
    collection do
      get 'unfollow' => 'follows#batch_destroy'
    end
    resources :releases
    get 'follow' => 'follows#create'
    get 'unfollow' => 'follows#destroy'
    #resources :suggests, :except => [:destroy,:edit]
    get 'unsuggest' => 'suggests#destroy'
  end

  # Allows us to have intuitive /artist/1/follow URLs that actually deal with the
  # user controller
  # resources :artists, :controller => 'users'

end
