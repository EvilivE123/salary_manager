Rails.application.routes.draw do
  get "insights/index"
  get  '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  resources :employees
  root "employees#index"
  get '/dashboard', to: 'insights#index', as: :dashboard
end