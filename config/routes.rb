Rails.application.routes.draw do
  devise_for :users,  controllers: { omniauth_callbacks: 'callbacks' }
  root  'home#index'
  get 'cla/:organisation/:repository' => 'cla#show', as: :cla

  resources :organizations, only: [:index, :show]
  resources :repositories, only: [:show]

  devise_scope :user do
    delete 'destroy_user_session' => 'callbacks#destroy'
  end
end
