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
        post "", to: "influencers#new"
        put "/:id", to: "influencers#update"
        delete "/:id", to: "influencers#remove"
      end

      scope "users" do
        post "", to: "users#new"
        put "/:id", to: "users#update"
        delete "/:id", to: "users#remove"
      end

      scope "orders" do
        post "", to: "orders#new"
        put "/:id", to: "orders#update"
        delete "/:id", to: "orders#remove"
      end
    end
  end
end
