Rails.application.routes.draw do
  devise_for :users

  root 'home#index'
  get 'home/index'

  resources :time_frames, except: [:new] do
    member do
      get :start
      get :stop
    end

    collection do
      get :report
    end
  end
end
