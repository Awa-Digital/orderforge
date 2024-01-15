namespace :v2, path: 'v2' do
  namespace :be do
    namespace :business do
      scope "auth" do
        post "login", to: "admin_users#login"
      end
    end
  end
end
