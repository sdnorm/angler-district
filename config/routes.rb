Rails.application.routes.draw do

  get '/order/:id/paypal_charge', to: 'paypal_charge#express', as: :paypal_express

  get 'categories', to: 'categories#index', as: :categories

  resources :charges

  get 'user_profile', to: 'user_profiles#show', as: :user_profile

  get 'user/:id', to: 'user_profiles#index', as: :public_user_profile

  get '/user_profile/:id/edit', to: 'user_profiles#edit', as: :edit_user_profile

  patch 'user_profile/:id', to: 'user_profiles#update'
  put 'user_profile/:id', to: 'user_profiles#update'
  delete 'user_profile/:id', to: 'user_profiles#destroy'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: "omniauth_callbacks"
  }

  # get 'omniauth_callbacks/stripe_connect'

  get 'route_order', to: 'route_order#route_order', as: :route_order

  get 'transactions/new'

  get 'carts/show', to: 'carts#show', as: :cart

  get '/about', to: 'pages#about', as: :about

  get '/terms_and_policies', to: 'pages#terms_and_policies', as: :terms_and_policies

  get '/sell_your_tackle', to: 'pages#sell_your_tackle', as: :sell_your_tackle

  get '/contact', to: 'pages#contact', as: :contact

  root 'pages#home'

  get 'paypal/success', to: 'pages#paypal_success', as: :paypal_success

  get 'paypal/failure', to: 'pages#paypal_failure', as: :paypal_failure

  get 'paypal/ipn', to: 'pages#paypal_ipn', as: :paypal_ipn


  #orders and grouped orders stuff
  get 'complete-order/:id', to: 'orders#purchase', as: :complete_order
  get 'complete-grouporder/:id', to: 'grouped_orders#purchase', as: :complete_grouporder

  get 'charged-order/:id', to: 'orders#charged', as: :charged_order
  get 'charged-grouporder/:id', to: 'grouped_orders#charged', as: :charged_orderorder

  resources :products

  resources :grouped_orders

  # devise_for :users
  # devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  get 'my-products', to: 'user_products#index', as: :all_user_products
  get 'edit-product/product/:id', to: 'products#edit', as: :edit_user_product

  # resources :products do
  #   resources :orders
  # end

  resources :orders

  resource :cart do
    put 'add/:product_id', to: 'carts#add', as: :add_to
    put 'remove/:product_id', to: 'carts#remove', as: :remove_from
  end

  resources :transactions, only: [:new, :create]

  # at the bottom because I want the URL to read anglerdistrict.com/reels
  get 'rods', to: 'categories#rods', as: :rods
  get 'reels', to: 'categories#reels', as: :reels
  get 'lures', to: 'categories#lures', as: :lures
  get 'apparel', to: 'categories#apparel', as: :apparel
  get 'boating', to: 'categories#boating', as: :boating
  get 'electronics', to: 'categories#electronics', as: :electronics
  get 'general', to: 'categories#general', as: :general

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
