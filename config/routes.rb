Rails.application.routes.draw do
  devise_for :users,  controllers: { omniauth_callbacks: 'callbacks' }
  root  'home#index'

  post 'trigger_refresh' => 'organizations#trigger_refresh'
  get  '/cla/:organization/:repository', to: 'clas#display_for_signing', as: :cla_repository
  get  '/cla_version/:cla/:version', to: 'clas#cla_version', as: :cla_version

  resources :organizations, only: [:index, :show]
  resources :repositories, only: [:show, :update]

  resources :clas, except: [:destroy]
  resources :cla_signatures, only: [:create]

  devise_scope :user do
    delete 'destroy_user_session' => 'callbacks#destroy'
  end
end
