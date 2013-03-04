Facturablock::Application.routes.draw do

  devise_for :users

  resources :invoices
  resources :customers

  match '/invoices/pdf/:id' => 'invoices#pdf', :via => :get, :as => 'invoice_pdf'

  match '/preferences' => 'preferences#index', :via => :get, :as => 'preferences'
  match '/preferences' => 'preferences#save', :via => :put, :as => 'save_preferences'

  authenticated :user do
    root :to => "invoices#index"
  end

  devise_scope :user do
    root :to => "devise/sessions#new"
  end

end
