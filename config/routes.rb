Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users

  root to: 'questions#index'

  resources :attachments, only: :destroy

  resources :links, only: :destroy

  resources :awards, only: :index

  concern :votable do
    member do
      patch :upvote
      patch :downvote
      patch :dropvote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true, except: :index do
      member { patch :flag_best }
      get 'links'
    end
  end
end
