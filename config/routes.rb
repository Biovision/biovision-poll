Rails.application.routes.draw do
  resources :polls
  resources :poll_questions, :poll_answers, except: [:index, :new, :show]

  namespace :admin do
    resources :polls, only: [:index, :show] do
      member do
        post 'toggle', defaults: { format: :json }
      end
    end
    resources :poll_questions, only: [:show] do
      member do
        post 'toggle', defaults: { format: :json }
        post 'priority', defaults: { format: :json }
      end
    end
    resources :poll_answers, only: [:show] do
      member do
        post 'priority', defaults: { format: :json }
      end
    end
  end
end
