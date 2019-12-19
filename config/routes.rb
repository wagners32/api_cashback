Rails.application.routes.draw do
  resources :users, param: :_username
  resources :purchases, only: %i[index edit create update destroy]
  
  get '/', to: 'home#index'
  post '/auth/login', to: 'authentication#login'
  get '/cashback', to: 'purchases#cashback'
  get '/*a', to: 'application#not_found'
 
end
