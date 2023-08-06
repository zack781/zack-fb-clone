Rails.application.routes.draw do
  # devise_for :users, except: :registrations
  devise_for :users, controllers: {
      registrations: 'users/registrations'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "posts#index"

  resources :users

  post '/users/add_friend', to: 'users#add_friend'
  post 'users/accept_friend_request', to: 'users#accept_friend_request'

  get '/posts/comment', to: 'posts#comment'
  post '/posts/add_comment', to: 'posts#add_comment'

  post '/posts/add_like', to: 'posts#add_like'

  post '/posts', to: 'posts#create'

#  match 'auth/:provider/callback', to: 'sessions#create'
#  match 'auth/failure', to: redirect('/')
#  match 'signout', to: 'sessions#destroy', as: 'signout'

  # devise_for :users, controllers: {
  #    registrations: 'users/registrations'
  # }
end
