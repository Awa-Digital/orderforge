namespace :v2, path: 'v2' do
  namespace :be do
    namespace :admin do
      scope "auth" do
        post "login", to: "auth#login"
      end

      scope "categories" do
        post "", to: "categories#new"
        delete "/:id", to: "categories#remove"
      end

      scope "products" do
        post "", to: "products#new"
        put "/:id", to: "products#update"
        delete "/:id", to: "products#remove"
      end

      scope "franchises" do
        post "", to: "franchise#new"
        put "/:id", to: "franchise#update"
        delete "/:id", to: "franchise#remove"
      end

      scope "influencers" do
        get "search", to: "influencers#search"
        post "", to: "influencers#new"
        put "/:id", to: "influencers#update"
        delete "/:id", to: "influencers#remove"
        scope ":id" do
          post "/vouchers", to: "influencers#new_voucher"
          put "/vouchers/:voucher_id", to: "influencers#update_voucher"
          delete "/vouchers/:voucher_id", to: "influencers#remove_voucher"
          get "/vouchers/search", to: "influencers#search_voucher"
        end
      end

      scope "users" do
        post "", to: "users#new"
        put "/:id", to: "users#update"
        delete "/:id", to: "users#remove"
        get "/search", to: "users#search"
      end

      scope "orders" do
        post "", to: "orders#new"
        put "/:id", to: "orders#update"
        delete "/:id", to: "orders#remove"
        get "/search", to: "orders#search"
      end

      scope "inventories" do
        post "", to: "inventories#new"
        put "/:id", to: "inventories#update"
        delete "/:id", to: "inventories#remove"
        get "/search", to: "inventories#search"
      end

      scope "stocks" do
        post "", to: "stocks#new"
        put "/:id", to: "stocks#update"
        delete "/:id", to: "stocks#remove"
        get "/search", to: "stocks#search"
      end
    end
  end
end
