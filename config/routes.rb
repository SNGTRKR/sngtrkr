SNGTRKRR::Application.routes.draw do

  if(Rails.env == "development")
    root :to => "Pages#home"
  else
    root :to => "Pages#splash"
  end
  match '/splash' => "Pages#splash"
  match '/home' => "Pages#home"
  match '/about' => "Pages#about"
  match '/terms' => "Pages#terms"
  match '/team' => "Pages#team"
  match '/privacy' => "Pages#privacy"
  match '/help' => "Pages#help"
  match '/recommended' => "Pages#recommended"

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' # Feel free to change '/admin' to any namespace you need.

  devise_for :users, :controllers => { :omniauth_callbacks => "users_controller/omniauth_callbacks" }
  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  match '/timeline' => "Users#timeline"
  resources :users do
    resources :manages
    member do
      get 'destroy_confirm'
      get 'manage_confirm'
      get 'managing'
      get 'friends'
      get 'recommend'
    end
    collection do
      get 'me', :action => 'self'
    end
  end

  resources :artists do
    collection do
      get 'no_results', :action => 'no_results'
    end
    resources :releases
  end

  # Allows us to have intuitive /artist/1/follow URLs that actually deal with the
  # user controller
  resources :artists, :controller => 'users' do
    member do
      get 'manage'
      get 'unmanage'
      get 'follow'
      get 'unfollow'
      get 'suggest'
      get 'unsuggest'
    end
  end

  resources :labels
  #  Use this line for production
  # unless Rails.application.config.consider_all_requests_local
  #   match '*not_found', to: 'errors#error_404'
  #  end

  # Use this line to view error in development
  match '*not_found', to: 'errors#error_404'

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
