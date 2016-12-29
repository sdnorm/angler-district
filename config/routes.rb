Rails.application.routes.draw do

  get '/about', to: 'pages#about', as: :about

  get '/terms_and_policies', to: 'pages#terms_and_policies', as: :terms_and_policies

  get '/sell_your_tackle', to: 'pages#sell_your_tackle', as: :sell_your_tackle

  get '/contact', to: 'pages#contact', as: :contact

  root 'pages#home'

  resources :products

  devise_for :users

  resources :products do
    resources :orders
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
