Rails.application.routes.draw do
  devise_for :users, controllers: {registrations:'users/registrations'}
  root 'posts#index'
  resources :posts
  get 'mypage', to: 'posts#mypage'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
