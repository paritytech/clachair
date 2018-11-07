Rails.application.routes.draw do
  devise_for :users,  controllers: { omniauth_callbacks: 'callbacks' }
  root  'home#index'

  resources :organizations, only: [:index, :show]
  resources :repositories, only: [:show, :update]
  resources :clas

  devise_scope :user do
    delete 'destroy_user_session' => 'callbacks#destroy'
  end
end
