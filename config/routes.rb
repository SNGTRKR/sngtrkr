SNGTRKRR::Application.routes.draw do

#require 'resque/server'
#mount Resque::Server.new, :at => "/resque"
  if(Rails.env == "development")
    root :to => "Pages#home"
  else
    root :to => "Pages#splash"
  end
  match '/manage' => "Pages#manage"
  match '/recommended' => "Pages#recommended"
  match '/home' => "Pages#home"
  match '/splash' => "Pages#splash"
  #  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' # Feel free to change '/admin' to any namespace you need.

  devise_for :users, :controllers => { :omniauth_callbacks => "users_controller/omniauth_callbacks" }
  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
  match 'users/me' => 'users#self'
  # Use this address through AJAX to import all a user's facebook artists.
  resources :users

  # Artist actions
  # Search for an artist by name
  match 'artists/search/:name' => 'artists#search'

  match 'artists/:artist_id/manage' => 'users#manage', :as => :manage_artist
  match 'artists/:artist_id/unmanage' => 'users#unmanage', :as => :unmanage_artist
  match 'artists/:artist_id/follow' => 'users#follow', :as => :follow_artist
  match 'artists/:artist_id/unfollow' => 'users#unfollow', :as => :unfollow_artist
  match 'artists/:artist_id/suggest' => 'users#suggest', :as => :suggest_artist
  match 'artists/:artist_id/unsuggest' => 'users#unsuggest', :as => :unsuggest_artist
  resources :artists

  resources :releases

  resources :labels

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
