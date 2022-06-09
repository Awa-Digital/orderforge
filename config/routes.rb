Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    # API for Mobile App
    namespace :v1, path: 'v1' do
      scope 'auth' do
        post 'signup', to: 'users#signup'
        post 'login', to: 'users#login'
      end

      scope 'products' do
        get 'all', to: 'products#index'
        get 'product', to: 'products#show'
      end
    end
  end
end
