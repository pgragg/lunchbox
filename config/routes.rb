Rails.application.routes.draw do

  get 'matches/invalidate_match'

  resources :years do
    resources :trimesters 
  end
  resources :holidays   
  resources :summaries do 
    post '/next_day' => 'summaries#next_day', as: :next_day
    post '/previous_day' => 'summaries#previous_day', as: :previous_day
   end 
  resources :menu do 
    post '/delete_all_lunches' => 'menu#delete_all_lunches', as: :delete_all_lunches
    post '/populate_with_blanks' => 'menu#populate_with_blanks', as: :populate_with_blanks
  end
  
  devise_for :users, controllers: {
                    sessions: 'users/sessions', 
                    registrations: 'users/registrations',
                    confirmations: 'users/confirmations' }
  resources :users do #, :controllers => {:registrations => "registrations"} 
    resources :children do 
      resources :menu, only: [:show]
    end 
    # post '/visit_menu' => 'users#visit_menu', as: :visit_menu
  end 
  resources :children do #Added here experimentally to allow searching.
    get '/search' => 'children#search', as: :search #URL, controller method, path. 
    get '/find_duplicates' => 'children#find_duplicates', as: :find_duplicates
    get '/remove_match_and_child' => 'children#remove_match_and_child', as: :remove_match_and_child
    get '/invalidate' => 'matches#invalidate', as: :invalidate
    # post '/visit_menu' => 'children#visit_menu', as: :visit_menu
  end  
  resources :welcome 
  resources :admin_panel 
  devise_scope :user do
    #root "devise/registrations#new"
    root 'welcome#index'
    
  end
  resources :lunches do 
    resources :lunch_choices 
      # post '/bagel_choice' => 'lunch_choices#bagel_choice', as: :bagel_choice
  end
  resources :daily_lunches 
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
