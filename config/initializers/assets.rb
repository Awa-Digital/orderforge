# config/initializers/assets.rb

Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w[application.js application.css active_admin.js]
Rails.application.config.assets.precompile << "bootstrap.min.js"
