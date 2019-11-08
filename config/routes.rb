Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
                                  omniauth_callbacks: 'oauth_callbacks',
                                  confirmations: 'oauth_confirmations'
                                  }

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

  concern :commentable do |options|
    resources :comments, options
  end

  resources :questions, concerns: :votable do
    concerns :commentable, only: :create, defaults: { commentable: 'question' }
    resources :answers, concerns: :votable, shallow: true, except: :index do
      concerns :commentable, only: :create, defaults: { commentable: 'answer' }
      member { patch :flag_best }
      get 'links'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        #  'on: :collection' to get route path without 'id' (then 'on: :member' instead, with 'id')
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
