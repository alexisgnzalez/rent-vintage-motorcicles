Rails.application.routes.draw do
  # Users routes
  devise_for :users

  # Route to the homepage
  root to: 'offers#home'

  # The rest of the routes
  resources :offers do
    resources :bookings, only: %i[new create]
  end
  resources :bookings, only: %i[destroy]
end
