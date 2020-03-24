# frozen_string_literal: true

Rails.application.routes.draw do
  concern :check do
    post :check, on: :collection, defaults: { format: :json }
  end

  concern :toggle do
    post :toggle, on: :member, defaults: { format: :json }
  end

  concern :priority do
    post :priority, on: :member, defaults: { format: :json }
  end

  resources :polls, :poll_questions, :poll_answers, only: %i[update destroy]

  scope '(:locale)', constraints: { locale: /ru|en|sv/ } do
    resources :polls, except: %i[update destroy], concerns: :check do
      member do
        post 'results' => :answer
        get 'results'
      end
    end
    resources :poll_questions, :poll_answers, only: %i[create edit], concerns: :check

    namespace :admin do
      resources :polls, only: %i[index show], concerns: :toggle do
        member do
          get 'users'
          post 'users' => :add_user, defaults: { format: :json }
          delete 'users/:user_id' => :remove_user, as: :user, defaults: { format: :json }
        end
      end
      resources :poll_questions, only: :show, concerns: %i[priority toggle]
      resources :poll_answers, only: :show, concerns: :priority
    end
  end
end
