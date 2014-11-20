Rails.application.routes.draw do
  
  
  root  'application#index'
  get 'apps4all/add_cmp' => 'apps4all#add_cmp'
  get 'apps4all/show' => 'apps4all#show'
  get 'apps4all/apps4all' => 'apps4all#show'
  
  get 'schools/show_language_courses' => 'schools#show_language_courses'
  get 'schools/language_courses' => 'schools#show_language_courses'
  
  get 'schools/show_universities' => 'schools#show_universities'
  get 'schools/universities' => 'schools#show_universities'
  
  get 'schools/show_private_schools' => 'schools#show_private_schools'
  get 'schools/private_schools' => 'schools#show_private_schools'
  
  get 'schools/show_lyceums' => 'schools#show_lyceums'
  get 'schools/lyceums' => 'schools#show_lyceums'
  
  get 'churches/show_all' => 'churches#show_all'
  get 'churches/churches' => 'churches#show_all'
  
  get 'publishers/show_all' => 'publishers#show'
  get 'publishers/publishers' => 'publishers#show'
  
  get 'vash_dosugs/show_all' => 'vash_dosugs#show'
  get 'vash_dosugs/vash_dosug' => 'vash_dosugs#show'

  get 'day19112014/show/:id' => 'day19112014#show'
  get 'day19112014/getXls/:id' => 'day19112014#getXls'
  
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
