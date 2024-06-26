Rails.application.routes.draw do
  # constraints(domain: 'bit.sh') do
  #   get '/:short_code', to: 'urls#redirect', as: :bit_redirect
  # end
    
  namespace :account do
    resources :accommondations, only: [:index, :new, :create] do
       member do
        get :print, defaults: { format: 'pdf' }
      end
    end

    get 'dashboard', to: 'dashboard#home'
    post 'revert_masquerade', to: "dashboard#revert_masquerade"
    # setting
    get 'settings/change_password', to: 'setting#change_password'
    get 'settings/profile', to: 'setting#profile'

  end


  namespace :admin do
    resources :accommondations, only: [:index] do
       member do
        get :print, defaults: { format: 'pdf' }
      end
    end
    resources :payment_methods, only: [:create, :destroy]

    resources :currency_pairs, only: [:create, :destroy] do
      collection do
        post :import_csv
      end
    end

    resource :site, only: [:new, :create, :edit, :update]
    get 'dashboard', to: 'dashboard#home'
    get 'users', to: 'dashboard#users'
    get 'users/:id', to: 'dashboard#show'
    post 'masquerade_as_account', to: 'dashboard#masquerade_as_account'
    # delete account
    delete 'users/:id', to: 'dashboard#destroy'
    # mails
    get 'emails', to: 'email#sent'
    get 'email/new', to: 'email#new'
    post 'emails', to: 'email#create'
        # settings
    get 'settings/account', to: 'setting#account'
    get 'settings/password', to: 'setting#admin_password'
    get 'settings/site_details', to: 'setting#site_details'

    resources :room_types
    resources :rooms
  end

  devise_for :accounts, controllers: {
    sessions: 'accounts/sessions',
    registrations: 'accounts/registrations',
    passwords: 'accounts/passwords',
    confirmations: 'accounts/confirmations'
    }, path: 'auth', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'secret',
    registration: 'students',
    sign_up: 'sign_up'
  }

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    }, path: 'admin', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'secret',
    confirmation: 'verification',
    unlock: 'unblock',
    registration: 'user',
    sign_up: 'sign_up'
  }

  root 'pages#home'

  post '/fetch_title', to: 'title_fetcher#fetch_title'
end
