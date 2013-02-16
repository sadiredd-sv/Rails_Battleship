Battleship::Application.routes.draw do

  resources :game_histories

  root to: "static_pages#main"

  match '/rules', to: 'static_pages#rules'
  #match '/main', to: 'static_pages#main'
  match '/signup',    to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  resources :grids

  resources :sessions, only: [:new, :create, :destroy]

  '''
  User nested resources to simplify the message complexity.
  For example
      /rooms
  '''
  
  resources :users
  resources :chats

  resources :rooms do
    post 'deploy_ships', on: :member
    get 'join', on: :member
    get 'leave', on: :member
    get 'ready', on: :member
    get 'play', on: :member
    get 'list', on: :collection
    get 'list_users', on: :member
    get 'game_status', on: :member
    get 'ship_list', on: :member
    get 'grid_list', on: :member
    post 'change_status', on: :member
    post 'fire', on: :member
  end

  match '/rooms/:id/user/:user_id',  to: 'rooms#grid_list_by_user'

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
