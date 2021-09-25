Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :merchants, only: [] do
    get  '/dashboard', to: 'merchants#show'

    get  '/invoices',     to: 'merchant_invoices#index'
    get  '/invoices/:id', to: 'merchant_invoices#show', as: 'invoice'

    get  '/items',     to: 'merchant_items#index'
    post '/items',     to: 'merchant_items#create'

    resources :bulk_discounts, only: [:index, :new, :show]
    resources :items,     only: [:new, :show, :edit, :update]
  end

  resources :admin, only: [:index]

  namespace :admin do
    resources :invoices, only: [:index, :show, :update]
    resources :merchants, only: [:index, :show, :edit, :update, :new, :create]
  end
end
