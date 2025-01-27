# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application"

pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3
pin "active_admin", to: "active_admin.js", preload: true

pin_all_from File.expand_path("../app/javascript/active_admin", __dir__), under: "active_admin", preload: true
