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
        post 'product/like', to: 'products#like'
        get 'favourites', to: 'products#favourites'
        post 'product/unlike', to: 'products#unlike'
        get 'search', to: 'products#search'
      end

      namespace :profile do
        scope 'addresses' do
          post 'add', to: 'addresses#new_address'
          get 'all', to: 'addresses#index'
          get 'show', to: 'addresses#show'
          delete 'remove', to: 'addresses#remove'
        end

        scope 'notification' do
          get 'settings', to: 'notification#settings'
          get 'settings/update', to: 'notification#update_settings'
        end
      end
    end
  end
end
