Rails.application.routes.draw do
  resources :users, param: :_username
  resources :purchases, only: %i[index edit create update destroy]
  
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
