Rails.application.routes.draw do
  # Users routes
  devise_for :users

  # Route to the homepage
  root to: 'offers#home'

  # Route for booked
  get 'booked', to: 'bookings#booked', as: :booked

  # Route for garage
  get 'garage', to: 'offers#garage', as: :garage

  # The rest of the routes
  resources :offers do
    resources :bookings, only: %i[new create edit update]
  end
  resources :bookings, only: %i[destroy]
end
