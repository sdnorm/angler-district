Rails.application.routes.draw do

  namespace :paypal do
    get 'route_charge/index'
  end

  # paypal payments
  get 'route-paypal/:id', to: 'paypal/route_charge#index', as: :route_paypal_order
  get 'paypal-payment/:id/create', to: 'paypal/single_item_order#index', as: :paypal
  get 'paypal-payments/:id/create', to: 'paypal/route_multi_item#index', as: :paypals
  get 'paypal-payment2/:id/create', to: 'paypal/two_item_order#index', as: :two_item_paypal_order
  # get 'paypal-payment2/:id/paypal_charged', to: 'paypal/2_item_order#show', as: :two_item_paypal_order_show
  get 'paypal-payment3/:id/create', to: 'paypal/three_item_order#index', as: :three_item_paypal_order
  # get 'paypal-payment3/:id/paypal_charged', to: 'paypal/3_item_order#show', as: :three_item_paypal_order_show
  get 'paypal-payment4/:id/create', to: 'paypal/four_item_order#index', as: :four_item_paypal_order
  # get 'paypal-payment4/:id/paypal_charged', to: 'paypal/4_item_order#show', as: :four_item_paypal_order_show
  get 'paypal-payment5/:id/create', to: 'paypal/five_item_order#index', as: :five_item_paypal_order
  # get 'paypal-payment5/:id/paypal_charged', to: 'paypal/5_item_order#show', as: :five_item_paypal_order_show
  get 'paypal-payment6/:id/create', to: 'paypal/six_item_order#index', as: :six_item_paypal_order
  # get 'paypal-payment6/:id/paypal_charged', to: 'paypal/6_item_order#show', as: :six_item_paypal_order_show
  get 'paypal-payment7/:id/create', to: 'paypal/seven_item_order#index', as: :seven_item_paypal_order
  # get 'paypal-payment7/:id/paypal_charged', to: 'paypal/7_item_order#show', as: :seven_item_paypal_order_show
  get 'paypal-payment8/:id/create', to: 'paypal/eight_item_order#index', as: :eight_item_paypal_order
  # get 'paypal-payment8/:id/paypal_charged', to: 'paypal/8_item_order#show', as: :eight_item_paypal_order_show
  get 'paypal-payment9/:id/create', to: 'paypal/nine_item_order#index', as: :nine_item_paypal_order
  # get 'paypal-payment9/:id/paypal_charged', to: 'paypal/9_item_order#show', as: :nine_item_paypal_order_show
  get 'paypal-orders/:id/create', to: 'paypal/more_than_9_items_order#index', as: :more_than_nine_items_paypal_order
  # get 'paypal-orders/:id/paypal_charged', to: 'paypal/more_than_9_items_order#show', as: :more_than_nine_items_paypal_order_show
  get 'paypal-orders/:id/paypal_charged', to: 'paypalroute_multi_item#show', as: :multiple_paypal_show

  #stripe payments
  get 's-payments/:id/create', to: 'stripe/multi_item_order#index', as: :stripes
  get 's-payment/:id/create', to: 'stripe/single_item_order#index', as: :stripe

  get 'route_charged_order/index', to: 'route_charged_order#index', as: :route_charged_order

  get 'handle_stripe_group_orders/index'

  get 'shipped_orders', to: 'shipped_order#index', as: :shipped_orders
  get 'shipped_order/:id', to: 'shipped_order#show', as: :shipped_order

  get 'to_ship_orders', to: 'to_ship_order#index',as: :to_ship_orders
  get 'to_ship_order/:id', to: 'to_ship_order#show', as: :to_ship_order

  get 'purchased_orders', to: 'purchased_order#index', as: :purchased_orders
  get 'purchased_order/:id', to: 'purchased_order#show', as: :purchased_order

  get 'my-orders', to: 'orders#index', as: :user_orders

  get 'route_paypal/index', to: 'route_paypal#index', as: :route_paypal

  resources :grouped_charges

  get 'brands/index', to: 'brands#index', as: :brands
  get 'saltwater/:id', to: 'brands#salt', as: :salt_brands
  get 'freshwater/:id', to: 'brands#fresh', as: :fresh_brands
  get 'saltwater/categories/:id', to: 'categories#salt_rods', as: :salt_categories
  get 'freshwater/categories/:id', to: 'categories#fresh_rods', as: :fresh_categories

  get 'order/:id/paypal_order', to: 'paypal_order#index', as: :paypal_index

  get 'paypal_order/:id/create', to: 'paypal_order#create', as: :paypal_create
  get 'paypal__grouped_order/:id/create', to: 'paypal_order#grouped_create', as: :paypal__grouped_create

  get 'order/:id/paypal_charged', to: 'paypal_order#show', as: :paypal_show

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


  # orders and grouped orders stuff
  get 'complete-order/:id', to: 'orders#purchase', as: :complete_order
  get 'complete-grouporder/:id', to: 'grouped_orders#purchase', as: :complete_grouporder

  post 'charged-order/:id', to: 'charges#create', as: :charged_order
  get 'charged-order/:id', to: 'orders#charged', as: :completed_order

  resources :products

  resources :grouped_orders

  get 'my-products', to: 'user_products#index', as: :all_user_products
  get 'edit-product/product/:id', to: 'products#edit', as: :edit_user_product

  get 'sold-orders', to: 'orders#sold_orders', as: :sold_orders

  resources :orders

  resource :cart do
    put 'add/:product_id', to: 'carts#add', as: :add_to
    put 'remove/:product_id', to: 'carts#remove', as: :remove_from
  end

  get 'orders/cart/get-cart-total', to: 'carts#get_cart_total', as: :js_cart_total
  get 'grouped_orders/cart/get-cart-total', to: 'carts#get_cart_total'
  get 'complete-grouporder/cart/get-cart-total', to: 'carts#get_cart_total'
  get 'carts/cart/get-cart-total', to: 'carts#get_cart_total'

  resources :transactions, only: [:new, :create]

  get 'rods', to: 'categories#rods', as: :rods
  get 'reels', to: 'categories#reels', as: :reels
  get 'lures', to: 'categories#lures', as: :lures
  get 'apparel', to: 'categories#apparel', as: :apparel
  get 'boating', to: 'categories#boating', as: :boating
  get 'electronics', to: 'categories#electronics', as: :electronics
  get 'general', to: 'categories#general', as: :general

  get 'faq', to: 'pages#faq', as: :faq
  get 'tackle-condition-guide', to: 'pages#tackle_condition_info', as: :tackle_condition_guide
  get 'how-to-sell', to: 'pages#sell_your_tackle', as: :how_to_sell
  get 'buyer-protection', to: 'pages#buyer_protection', as: :buyer_protection
  get 'fees', to: 'pages#fees', as: :fees

  get ':id', to: 'brands#show', as: :brand

end
