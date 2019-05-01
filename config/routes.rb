Rails.application.routes.draw do
  devise_for :users

  root 'home#index'
  get 'home/index'

  resources :time_frames do
    member do
      get :start
      get :stop
    end

    collection do
      get :report
    end
  end
end
