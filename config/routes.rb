Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  namespace :api, defaults: {format: :json}  do
    namespace :v1 do
      resources :feedbacks, param: :number, only: %i[index show create] do
        collection do
          get 'count'
        end
      end
      resources :states, only: :index
    end
  end
end
