Rails.application.routes.draw do
  resources :polls, :poll_questions, :poll_answers, only: %i[update destroy]

  scope '(:locale)', constraints: { locale: /ru|en|sv/ } do
    resources :polls, except: %i[update destroy] do
      member do
        post 'results' => :answer
        get 'results'
      end
    end
    resources :poll_questions, :poll_answers, only: %i[create edit]

    namespace :admin do
      resources :polls, only: %i[index show] do
        member do
          post 'toggle', defaults: { format: :json }
          get 'users'
          post 'users' => :add_user, defaults: { format: :json }
          delete 'users/:user_id' => :remove_user, as: :user, defaults: { format: :json }
        end
      end
      resources :poll_questions, only: :show do
        member do
          post 'toggle', defaults: { format: :json }
          post 'priority', defaults: { format: :json }
        end
      end
      resources :poll_answers, only: :show do
        member do
          post 'priority', defaults: { format: :json }
        end
      end
    end
  end
end
