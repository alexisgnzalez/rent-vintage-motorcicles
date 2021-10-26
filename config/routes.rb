Rails.application.routes.draw do
  # Users routes
  devise_for :users

  # Route to the homepage
  root to: 'offers#home'

  # The rest of the routes
  resources :offers do
    collection do
      get :garage # creates the route /offers/garage (my own motorcicles)
    end
    resources :bookings, only: %i[new create edit update]
  end
  resources :bookings, only: %i[destroy]
  get 'bookings/booked', to: 'bookings#booked'
end
