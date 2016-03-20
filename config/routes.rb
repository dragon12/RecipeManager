Rails.application.routes.draw do
  resources :future_recipes do
      member do
        get 'uprank'
        get'downrank'
        get 'set_state'
      end
  end


  get 'future_recipes/add_or_update'


  get 'tags/index'

  get 'tags/create'

  get 'tags/show'

  get 'tags/update'

  get 'tags/destroy'

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  get 'users/new'

  get 'categories/index'

  get 'categories/create'

  get 'categories/show'

  get 'categories/update'

  get 'categories/destroy'

  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root :controller => 'recipes', :action => 'root_index'
  #root "recipes#root_index"
  root "welcome#index"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :recipes do
      resources :user_ratings, only: [:new, :create, :update, :destroy]
  end

  resources :ingredients
  resources :categories
  resources :tags
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create,:edit, :update]
  
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
