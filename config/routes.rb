Rails.application.routes.draw do

  root 'home#index'
  #root 'application#page_not_found'

  get 'lists' => 'home#lists'
  get 'add' => 'home#add'
  get 'play/:id/:n' => 'home#play', as: :play

  post 'verify' => 'home#verify'
  get 'verify' => 'home#index'

  get 'edit_search' => 'home#edit_search'
  
  post 'edit_search_verify' => 'home#edit_search_verify'
  get 'edit_search_verify' => 'home#edit_search'

  post 'edit/edit_verify' => 'home#edit_verify'
  get 'edit/edit_verify' => 'home#edit'

  get 'edit/:code' => 'home#edit', as: :edit

  get 'faq' => 'home#faq'


if Rails.env.production?
   get '404', :to => 'application#page_not_found'
end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
