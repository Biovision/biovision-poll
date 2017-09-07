Biovision::Poll::Engine.routes.draw do
  resources :polls
  resources :poll_questions, :poll_answers, except: [:index, :new, :show]

  namespace :admin do
    resources :polls, only: [:index, :show] do
      member do
        post 'toggle', defaults: { format: :json }
      end
    end
    resources :poll_questions, :poll_answers, only: [:show] do
      member do
        post 'toggle', defaults: { format: :json }
      end
    end
  end
end
