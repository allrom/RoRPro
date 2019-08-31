Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users

  root to: 'questions#index'

  resources :attachments, only: :destroy

  resources :questions do
    resources :answers, shallow: true, except: :index do
      member { patch :flag_best }
    end
  end
end
