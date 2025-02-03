# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_02_03_180133) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_verifications", force: :cascade do |t|
    t.string "phone"
    t.string "otp"
    t.string "email"
    t.string "email_token"
    t.boolean "email_verified", default: false
    t.boolean "phone_verified", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "addresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "street"
    t.string "state", default: "Lagos"
    t.string "country", default: "Nigeria", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "house_number"
    t.integer "delivery_area_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email"
    t.string "phone"
    t.string "first_name"
    t.string "last_name"
    t.boolean "super_user"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "ads", force: :cascade do |t|
    t.string "image"
    t.string "title"
    t.date "expiration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_id"
    t.string "url"
  end

  create_table "affiliate_views", force: :cascade do |t|
    t.string "ip"
    t.string "user_agent"
    t.string "influencer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auths", force: :cascade do |t|
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_type"
  end

  create_table "bank_details", force: :cascade do |t|
    t.string "account_name"
    t.string "account_number"
    t.string "account_type"
    t.string "bank_code"
    t.string "bank_name"
    t.string "currency"
    t.string "recipient_code"
    t.string "bankable_type"
    t.string "bankable_id"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "status", default: "active"
  end

  create_table "delivery_areas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "day_rate", precision: 8, scale: 2
    t.decimal "dusk_rate", precision: 8, scale: 2
    t.decimal "night_rate", precision: 8, scale: 2
    t.decimal "dawn_rate", precision: 8, scale: 2
    t.integer "region_id", default: 1
    t.string "status", default: "active"
  end

  create_table "department_roles", force: :cascade do |t|
    t.bigint "department_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
  end

  create_table "devices", force: :cascade do |t|
    t.integer "user_id"
    t.string "build_number"
    t.string "device_token"
    t.string "device_name"
    t.string "serial_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favourite_items", force: :cascade do |t|
    t.integer "favourite_id"
    t.integer "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favourites", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "franchise_addresses", force: :cascade do |t|
    t.integer "franchise_id"
    t.integer "region_id"
    t.integer "location_id"
    t.string "street"
    t.string "longitude"
    t.string "latitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "franchise_inventory_quantities", force: :cascade do |t|
    t.integer "franchise_id"
    t.integer "inventory_id"
    t.decimal "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "franchise_product_prices", force: :cascade do |t|
    t.integer "franchise_id"
    t.integer "product_id"
    t.decimal "amount", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "franchise_stock_quantities", force: :cascade do |t|
    t.integer "franchise_id"
    t.integer "stock_id"
    t.decimal "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "franchises", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.string "email"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "influencers", force: :cascade do |t|
    t.string "name"
    t.string "instagram_handle"
    t.string "twitter_handle"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.string "slug"
    t.integer "generated_views", default: 0
    t.string "phone_number"
    t.string "tiktok_handle"
    t.string "facebook_page_handle"
    t.integer "followers_count"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.string "state"
    t.boolean "expires"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
  end

  create_table "notification_settings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "push_notifications", default: true
    t.boolean "app_updates", default: true
    t.boolean "promotions", default: true
    t.boolean "receipts", default: true
    t.boolean "newsletter", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notification_settings_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.string "image"
    t.string "analytics_label"
    t.integer "user_id"
    t.boolean "seen", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_reference"
    t.string "notification_type"
  end

  create_table "order_addresses", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "house_number"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "delivery_area_id"
    t.integer "region_id"
    t.integer "location_id"
    t.index ["order_id"], name: "index_order_addresses_on_order_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "product_id"
    t.integer "quantity", default: 1
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "subtotal", precision: 8, scale: 2, default: "0.0"
  end

  create_table "order_status_stamps", force: :cascade do |t|
    t.integer "auth_id"
    t.integer "order_id"
    t.string "message"
    t.string "action", default: "update"
    t.string "action_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "address_id"
    t.integer "user_id"
    t.string "status", default: "initiated"
    t.boolean "completed"
    t.boolean "paid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference"
    t.string "recipient_name"
    t.string "recipient_phone"
    t.decimal "total", precision: 8, scale: 2, default: "0.0"
    t.string "recipient_email"
    t.datetime "processing_date", precision: nil
    t.integer "priority", default: 0
    t.boolean "sent_receipt_notification", default: false
    t.boolean "sent_processing_notification", default: false
    t.boolean "sent_delivering_notification", default: false
    t.boolean "sent_completed_notification", default: false
    t.boolean "sent_guest_receipt_notification", default: false
    t.string "order_no", default: "unassigned"
    t.integer "franchise_id"
    t.string "influencer_id"
  end

  create_table "password_reset_tokens", force: :cascade do |t|
    t.integer "user_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "total", precision: 8, scale: 2
    t.decimal "payment_charges", precision: 8, scale: 2
    t.integer "discount_id"
    t.integer "order_id"
    t.boolean "paid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "reference"
    t.string "gateway_reference"
    t.string "checkout_url"
    t.string "gateway"
    t.string "payment_id"
    t.integer "voucher_id"
    t.datetime "paid_at", precision: nil
  end

  create_table "product_ingredients", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "ingredient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_product_ingredients_on_ingredient_id"
    t.index ["product_id"], name: "index_product_ingredients_on_product_id"
  end

  create_table "product_inventory_items", force: :cascade do |t|
    t.integer "product_id"
    t.integer "inventory_id"
    t.decimal "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_purchase_counters", force: :cascade do |t|
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_item_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "image"
    t.integer "category_id"
    t.decimal "amount", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "liked"
    t.bigint "subcategory_id"
    t.integer "start_time", default: 0
    t.integer "end_time", default: 23
    t.string "status", default: "active"
    t.index ["subcategory_id"], name: "index_products_on_subcategory_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.decimal "rating", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_ratings_on_product_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "regions", force: :cascade do |t|
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "status", default: "active"
  end

  create_table "removables", force: :cascade do |t|
    t.bigint "order_item_id", null: false
    t.bigint "ingredient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_removables_on_ingredient_id"
    t.index ["order_item_id"], name: "index_removables_on_order_item_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
  end

  create_table "staff_departments", force: :cascade do |t|
    t.bigint "staff_id"
    t.bigint "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
  end

  create_table "staffs", force: :cascade do |t|
    t.bigint "franchise_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "avatar"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
  end

  create_table "stock_inventory_items", force: :cascade do |t|
    t.integer "stock_id"
    t.integer "inventory_id"
    t.decimal "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.string "state"
    t.boolean "expires"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
  end

  create_table "subcategories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_subcategories_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_otp"
    t.boolean "active", default: true
    t.string "avatar"
    t.decimal "spend_score", precision: 8, scale: 2, default: "0.0"
    t.string "slug"
    t.string "status", default: "active"
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "vouchers", force: :cascade do |t|
    t.string "title"
    t.string "discount_code"
    t.integer "influencer_id"
    t.decimal "discount_rate", precision: 4, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expiration_date"
    t.string "status", default: "active"
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "notification_settings", "users"
  add_foreign_key "order_addresses", "orders"
  add_foreign_key "product_ingredients", "ingredients"
  add_foreign_key "product_ingredients", "products"
  add_foreign_key "products", "subcategories"
  add_foreign_key "ratings", "products"
  add_foreign_key "ratings", "users"
  add_foreign_key "removables", "ingredients"
  add_foreign_key "removables", "order_items"
  add_foreign_key "subcategories", "categories"
end
