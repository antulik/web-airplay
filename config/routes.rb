Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#show'

  get 'jsonp' => 'home#jsonp'
  get 'version_check' => 'home#version_check'
  get 'refresh_devices' => 'home#refresh_devices'

  get 'img_play/:url', to: 'home#img_play', constraints: { url: /.+/ }

  resources :videos do
    delete 'clear', on: :collection
  end
  resource :player do
    post 'seek'
    post 'resume'
    post 'pause'
    get 'play'
    post 'current_device'
    get 'backbone_info'
  end

  namespace :api_v1 do
    resources :devices do

      collection do
        post 'refresh'
      end

      member do
        post 'pause'
        post 'seek'
        post 'resume'
        post 'play_url'
        get 'playback'
      end
    end

    resources :items
  end

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
