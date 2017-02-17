Rails.application.routes.draw do

  get 'omniauth_callbacks/stripe_connect'

  get 'transactions/new'

  get 'carts/show'

  get '/about', to: 'pages#about', as: :about

  get '/terms_and_policies', to: 'pages#terms_and_policies', as: :terms_and_policies

  get '/sell_your_tackle', to: 'pages#sell_your_tackle', as: :sell_your_tackle

  get '/contact', to: 'pages#contact', as: :contact

  root 'pages#home'

  get 'paypal/success', to: 'pages#paypal_success', as: :paypal_success

  get 'paypal/failure', to: 'pages#paypal_failure', as: :paypal_failure

  get 'paypal/ipn', to: 'pages#paypal_ipn', as: :paypal_ipn

  resources :products

  # devise_for :users
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

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

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
