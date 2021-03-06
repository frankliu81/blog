Rails.application.routes.draw do

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  get "/about" => "home#about"

  # get "/posts/new"        => "posts#new"    , as: :new_post
  # post "/posts"           => "posts#create" , as: :posts
  # get "/posts/:id"        => "posts#show"   , as: :post
  # get "/posts"            => "posts#index"
  # get "/posts/:id/edit"   => "posts#edit"   , as: :edit_post
  # patch "posts/:id"       => "posts#update"
  # delete "/posts/:id"     => "posts#destroy"

  get '/posts/favorites' => "favorites#index"

 # resources :favorites, only: [:index]
 #
  resources :posts do
    resources :comments
    resources :favorites, only: [:create, :destroy]
    get :search, on: :collection
  end

  # json api routes
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :posts, only: [:index, :show, :create]
    end
  end



  # http://guides.rubyonrails.org/routing.html
  # name space will generate the path with /users, with controller in
  # the users folder
  #namespace 'users' do

  # scope module: 'users': will generate the path without /users, but with
  # the child controllers in the users folder
  scope module: 'users' do
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :password_changes, only: [:edit, :update]
    resources :account_verifications, only: [:new, :create, :edit]
  end

  resources :users, only: [:new, :create, :edit, :update, :destroy]


  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
    #delete :destroy, on: :member # same one as the default generated
    #delete :destroy # includes the session_id
  end

  resources :tags, only: [:index]

  # callback for gmail
  #get "/auth/:provider/callback" => 'sessions#create'
  get "/auth/google_oauth2/callback" => 'callbacks#google'

  root "home#index"

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
