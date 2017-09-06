Rails.application.routes.draw do
  mount Biovision::Poll::Engine => "/biovision-poll"
end
