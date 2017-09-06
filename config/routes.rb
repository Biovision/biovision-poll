Biovision::Poll::Engine.routes.draw do
  resources :polls

  namespace :admin do
    resources :polls, only: [:index, :show]
  end
end
