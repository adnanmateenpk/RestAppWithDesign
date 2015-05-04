Rails.application.routes.draw do
  
  

 

  devise_for :users, :controllers => { registrations: 'users/registrations', sessions: "users/sessions" }, :path => "members"
  root to: 'main#index'
  patch "change-subscription" => 'main#convert_user'
  get "register" => 'main#register'
  get "dashboard" => 'admin#index'
  post "availability_restaurant" => 'main#restaurant'
  post "availability_customer" => 'main#customer'
  post "get_authenticity_token" => 'main#get_token'
  get "reservations" => 'main#reservations'
  scope :dashboard do
    get "settings" => 'admin#settings'
    patch "settings/save" => 'admin#settings_save'
    patch "settings/logo" => 'admin#remove_logo'
    resources :pages,:param => :slug do
      member do
          patch 'remove_image'
      end
    end
    resources :posts,:param => :slug do
      member do
          patch 'remove_image'
      end
    end
    resources :restaurants , :param => :slug do
      member do
        patch 'remove_image'
        
      end
      collection do 

        get 'list' 
      end
      resources :details ,:controller => :branches , :param => :slug do
        member do
          patch 'remove_image'
        end
        collection do 
          get 'list' 
        end
        
      end
    end
    resources :reservations,:param => :reservation_code do
      collection do 
        get "list/:id" => 'reservations#list'
        post "filtered_list"
      end
    end
    resources :customers, :controller =>"users" , :param => :membership do
      collection do 
        post "filtered"
        get "filtered"
      end
    end
   
     
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
