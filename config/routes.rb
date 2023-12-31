Rails.application.routes.draw do
  root "posts#index"
  devise_for :users

  resources :posts do
    resources :comments, except: :show
  end

  resources :posts do
    collection do
      post :import
    end
  end

  get '/:shorten_url', to: 'shortened_urls#redirect_to_post', as: :short_post
  
  resources :categories, except: :show
  namespace :user do
    resources :comments, :posts
  end
  namespace :api do
    namespace :v1 do
      resources :regions, only: %i[index show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: %i[index show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: %i[index show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: %i[index show], defaults: { format: :json }
    end
  end
end
