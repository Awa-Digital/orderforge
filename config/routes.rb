# frozen_string_literal: true

require "sidekiq/web"
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # ActiveAdmin.routes(self)

  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
  post "/graphql", to: "graphql#execute"
  # MUST be declared before the mount ForestLiana::Engine.

  # namespace :forest do
  #   post '/actions/print-receipt' => 'orders#print_receipt'
  #   post '/actions/verify-payment' => 'orders#verify_payment'
  #   post '/actions/mark-as-processing' => 'orders#mark_as_processing'
  #   post '/actions/mark-as-delivering' => 'orders#mark_as_delivering'
  #   post '/actions/mark-as-complete' => 'orders#mark_as_complete'
  # end

  # mount ForestLiana::Engine => '/forest'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # sidekiq routes
  # end sidekiq routes
  # admin routes
  if ENV['ADMIN_APP'] == 'true'
    ActiveAdmin.routes(self)
    devise_for :admin_users, ActiveAdmin::Devise.config

    root to: 'admin/dashboard#index'
    mount Sidekiq::Web => '/sidekiq'
  end
  # end admin routes

  namespace :api, defaults: { format: :json } do
    post 'record_visit', to: 'affiliate#register_view'
    draw('business')
    # API for Mobile App
    namespace :v1, path: 'v1' do
      scope 'auth' do
        post "influencer/signup", to: "influencer#signup"
        post "influencer/login", to: "influencer#login"
        post 'signup', to: 'users#signup'
        post 'signup/otp', to: 'users#verify_account'
        post 'verify', to: 'users#verify_email'
        post 'login', to: 'users#login'
        get 'show', to: 'users#show'
        put 'update', to: 'users#update'
        post 'reset/request', to: 'users#request_password_reset'
        post 'reset/update', to: 'users#reset_password'
        delete 'disable', to: 'users#disable'
        put 'avatar/update', to: 'users#update_avatar'
      end

      scope 'influencer' do
        get "user", to: "influencer#user"
        get "bank-list", to: "influencer#bank_list"
        post "resolve-account", to: "influencer#resolve_account"
        post "save-bank-account", to: "influencer#save_bank"
        post "withdraw", to: "influencer#withdraw"
        put "update-verification-video", to: "influencer#update_verification_video"
      end

      scope 'ads' do
        get '', to: 'ads#ads'
      end

      scope 'products' do
        get "categories", to: "products#categories"
        get 'all', to: 'products#index'
        get 'hot-deals', to: 'products#hot_deals'
        get 'grouped', to: 'products#grouped'
        get 'product', to: 'products#show'
        post 'product/like', to: 'products#like'
        get 'favourites', to: 'products#favourites'
        post 'product/unlike', to: 'products#unlike'
        get 'search', to: 'products#search'
      end

      scope 'cart' do
        get '', to: 'orders#cart'
        patch '', to: 'orders#update_cart'
        put '', to: 'orders#update_cart'
        post 'franchise', to: "orders#update_franchise"
        get 'track/:reference', to: "orders#get_paid_cart"
        post 'add', to: 'orders#add_for_signed_in_user'
        post 'create-and-add-to-cart', to: 'orders#add_multi'
        post 'guest/add', to: 'orders#add'
        post 'guest/create-and-add-to-cart', to: 'orders#create_guest_cart'
        post 'guest/update-address', to: 'orders#update_address'
        post 'update', to: 'orders#update'
        delete 'update/:order_item_id/ingredients/:ingredient_id', to: 'orders#remove_ingredient'
        delete 'remove', to: 'orders#remove'
        post 'add/address', to: 'orders#attach_address'
        post 'add/recipient', to: 'orders#attach_recipient'
        get 'address/areas', to: 'orders#address_areas'
        get 'address/franchises', to: 'orders#franchises'
        get 'address/regions', to: 'orders#address_regions'
        get 'address/regions/:region_id/areas', to: 'orders#regions_areas'
      end

      scope 'payment' do
        post 'initiate', to: 'payment#new'
        post 'add/discount', to: 'payment#attach_discount'
        post 'verify', to: 'payment#confirm'
        post 'pay/verify', to: 'payment#verify_with_webhook'
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
          post 'settings/update', to: 'notification#update_settings'
          post 'devices/new', to: 'notification#register_device'
        end

        scope 'transactions' do
          get 'all', to: 'transactions#index'
          get 'show', to: 'transactions#show'
        end

        scope 'leader' do
          get 'board', to: 'leader#board'
        end
      end

      namespace :be, path: 'ops' do
        scope 'auth' do
          post 'login', to: 'auth#login'
        end

        scope 'orders' do
          get '', to: 'orders#index'
          get 'search', to: 'orders#search'
          get 'filter/:status', to: 'orders#filter'
          get 'filter/:status/search', to: 'orders#filtered_search'
          get 'pending', to: 'orders#pending'
          post 'mark/accept/:order_id', to: 'orders#mark_as_accepted'
          post 'mark/processing/:order_id', to: 'orders#mark_as_processing'
          post 'mark/awaiting_packaging/:order_id', to: 'orders#mark_as_awaiting_packaging'
          post 'mark/packaged/:order_id', to: 'orders#mark_as_packaged'
          post 'mark/delivering/:order_id', to: 'orders#mark_as_delivering'
          post 'mark/completed/:order_id', to: 'orders#mark_as_completed'
          get 'download/:order_id', to: 'orders#download_pdf'
          get ':order_id/logs', to: 'orders#logs'
          post 'verify/:order_id', to: 'orders#verify'
          get 'order_items_counter', to: "orders#order_items_counter"
        end
      end
    end
  end
end
