Rails.application.routes.draw do

  # resources :brands
  namespace :api do
    namespace :v1 do
      get 'products/index'
      get 'products/show'
    end
  end

  namespace :stripe do
    get 'account_connection/index'
  end

  #stripe payments
  post 's-payments/charged-order/:id', to: 'stripe/multi_item_charges#create', as: :stripes_post
  post 's-payment/charged-order/:id', to: 'stripe/single_item_charges#create', as: :stripe_post
  # get 'charged-order/:id', to: 'orders#charged', as: :completed_order
  get 's-payments/:id/create', to: 'stripe/multi_item_order#index', as: :stripes
  get 's-payment/:id/create', to: 'stripe/single_item_order#index', as: :stripe

  # orders and grouped orders stuff
  get 'complete-order/:id', to: 'orders#purchase', as: :complete_order
  get 'complete-grouporder/:id', to: 'grouped_orders#purchase', as: :complete_grouporder
  get 'charged-order/:id', to: 'orders#charged', as: :completed_order
  resources :grouped_orders
  resources :orders

  # Products
  resources :products
  get 'my-products', to: 'user_products#index', as: :all_user_products
  get 'edit-product/product/:id', to: 'products#edit', as: :edit_user_product

  # User Orders
  get 'shipped_orders', to: 'shipped_order#index', as: :shipped_orders
  get 'shipped_order/:id', to: 'shipped_order#show', as: :shipped_order
  get 'purchased_orders', to: 'purchased_order#index', as: :purchased_orders
  get 'purchased_order/:id', to: 'purchased_order#show', as: :purchased_order
  get 'my-orders', to: 'orders#index', as: :user_orders
  get 'sold-orders', to: 'orders#sold_orders', as: :sold_orders

  # get /products(.:format)                                products#index
  # post /products(.:format)                                products#create
  # get /products/new(.:format)                            products#new
  # get /products/:id/edit(.:format)                       products#edit
  # get /products/:id(.:format)                            products#show
  # patch /products/:id(.:format)                            products#update
  # put /products/:id(.:format)                            products#update
  # delete /products/:id(.:format)                            products#destroy

  # get 'to_ship_orders', to: 'to_ship_order#index',as: :to_ship_orders
  # get 'to_ship_order/:id', to: 'to_ship_order#show', as: :to_ship_order
  resources :to_ship_order

  # Brand Names
  get 'brands/index', to: 'brands#index', as: :brands
  get 'saltwater/:id', to: 'brands#salt', as: :salt_brands
  get 'freshwater/:id', to: 'brands#fresh', as: :fresh_brands
  get 'saltwater/categories/:id', to: 'categories#salt_rods', as: :salt_categories
  get 'freshwater/categories/:id', to: 'categories#fresh_rods', as: :fresh_categories

  # Categories
  get 'categories', to: 'categories#index', as: :categories
  get 'rods', to: 'categories#rods', as: :rods
  get 'reels', to: 'categories#reels', as: :reels
  get 'lures', to: 'categories#lures', as: :lures
  get 'apparel', to: 'categories#apparel', as: :apparel
  get 'boating', to: 'categories#boating', as: :boating
  get 'electronics', to: 'categories#electronics', as: :electronics
  get 'general', to: 'categories#general', as: :general

  # User Profile and Things
  get 'user_profile', to: 'user_profiles#show', as: :user_profile
  get 'user/:id', to: 'user_profiles#index', as: :public_user_profile
  get '/user_profile/:id/edit', to: 'user_profiles#edit', as: :edit_user_profile
  patch 'user_profile/:id', to: 'user_profiles#update'
  put 'user_profile/:id', to: 'user_profiles#update'
  delete 'user_profile/:id', to: 'user_profiles#destroy'

  # Stripe Account Connection

  get 'sellers/stripe/authorize', to: 'stripe/account_connection#index', as: :first_stripe_step
  get 'sellers/stripe/token', to: 'stripe/account_connection#confirmation', as: :confirm_stripe

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: "omniauth_callbacks"
  }

  # Cart Things
  get 'carts/show', to: 'carts#show', as: :cart
  resource :cart do
    put 'add/:product_id', to: 'carts#add', as: :add_to
    put 'remove/:product_id', to: 'carts#remove', as: :remove_from
  end
  get 'orders/cart/get-cart-total', to: 'carts#get_cart_total', as: :js_cart_total
  get 'carts/cart/get-cart-total', to: 'carts#get_cart_total'
  get 'grouped_orders/cart/get-cart-total', to: 'carts#get_cart_total'
  get 'complete-grouporder/cart/get-cart-total', to: 'carts#get_cart_total'
  get 'complete-order/cart/get-cart-total', to: 'carts#get_cart_total'
  get 'carts/cart/get-cart-total', to: 'carts#get_cart_total'

  get 'route-order', to: 'route_order#route_order', as: :route_order

  # General Pages and Guides
  get '/about', to: 'pages#about', as: :about
  get '/terms_and_policies', to: 'pages#terms_and_policies', as: :terms_and_policies
  get '/sell_your_tackle', to: 'pages#sell_your_tackle', as: :sell_your_tackle
  get '/contact', to: 'pages#contact', as: :contact
  get 'faq', to: 'pages#faq', as: :faq
  get 'tackle-condition-guide', to: 'pages#tackle_condition_info', as: :tackle_condition_guide
  get 'how-to-sell', to: 'pages#sell_your_tackle', as: :how_to_sell
  get 'buyer-protection', to: 'pages#buyer_protection', as: :buyer_protection
  get 'fees', to: 'pages#fees', as: :fees

  get ':id', to: 'brands#show', as: :brand

  root 'pages#home'

end
