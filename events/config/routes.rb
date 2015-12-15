Rails.application.routes.draw do
  root 'hevents#index'

  resources :hevents
  get 'hevents/index'

  resources :events
  delete 'events', to: 'events#destroy_all'
end
