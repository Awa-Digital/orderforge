# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application"

pin "flowbite", preload: true # downloaded from https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.1/flowbite.min.js
pin "@rails/ujs", to: "rails_ujs_esm.js" # @7.1.3
pin "active_admin", to: "active_admin.js", preload: true

pin_all_from File.expand_path("../app/javascript/active_admin", __dir__), under: "active_admin", preload: true
pin "active_admin/product", preload: true
