Rails.application.routes.draw do
  devise_for :users,  controllers: { omniauth_callbacks: 'callbacks' }
  root  'home#index'

  get 'load_organizations' => 'organizations#load_organizations'
  get 'repositories/:id/cla/:cla_id', to: 'clas#show', as: :cla_repository

  resources :organizations, only: [:index, :show]
  resources :repositories, only: [:show, :update]

  resources :clas, except: [:destroy]

  devise_scope :user do
    delete 'destroy_user_session' => 'callbacks#destroy'
  end
end
