SNGTRKR::Application.routes.draw do

  match 'sitemap.xml' => 'sitemaps#sitemap'

  root :to => "application#home"
  
  match 'pages/:action' => 'pages#:action'

  namespace :admin do
    mount RailsAdmin::Engine => '/rails', :as => 'rails_admin'
  end
  
  match '/admin' => "Admin#overview"
  match '/admin/:action' => "Admin#:action"
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

# The priority is based upon order of creation:
# first created -> highest priority.

# Sample of regular route:
#   match 'products/:id' => 'catalog#view'
# Keep in mind you can assign values other than :controller and :action

# Sample of named route:
#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
# This route can be invoked with purchase_url(:id => product.id)

# Sample resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Sample resource route with options:
#   resources :products do
#     member do
#       get 'short'
#       post 'toggle'
#     end
#
#     collection do
#       get 'sold'
#     end
#   end

# Sample resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Sample resource route with more complex sub-resources
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', :on => :collection
#     end
#   end

# Sample resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end

# You can have the root of your site routed with "root"
# just remember to delete public/index.html.
# root :to => 'welcome#index'

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id))(.:format)'
end
