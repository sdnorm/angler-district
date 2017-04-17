# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170417185125) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
    t.boolean  "salt"
    t.boolean  "fresh"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "grouped_orders", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip_code"
    t.integer  "buyer_id"
    t.integer  "total"
    t.boolean  "purchased"
    t.datetime "purchased_at"
  end

  create_table "order_products", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "address1"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "product_id"
    t.integer  "buyer_id"
    t.integer  "seller_id"
    t.integer  "grouped_orders_id"
    t.string   "address2"
    t.integer  "total"
    t.boolean  "charged"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "zip_code"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.string   "paypal_first_name"
    t.string   "paypal_last_name"
    t.boolean  "purchased",         default: false
    t.datetime "purchased_at"
    t.string   "ip_address"
    t.integer  "grouped_order_id"
    t.string   "tracking_number"
    t.index ["grouped_orders_id"], name: "index_orders_on_grouped_orders_id", using: :btree
  end

  create_table "product_categories", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.float    "price"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "image"
    t.integer  "user_id"
    t.integer  "shop_id"
    t.string   "display_image"
    t.string   "image2"
    t.string   "image3"
    t.string   "image4"
    t.integer  "inventory",         default: 1
    t.string   "slug"
    t.integer  "category_id"
    t.string   "condition"
    t.integer  "brand_id"
    t.float    "shipping"
    t.integer  "price_in_cents"
    t.integer  "shipping_in_cents"
    t.string   "water_type"
    t.index ["category_id"], name: "index_products_on_category_id", using: :btree
    t.index ["shop_id"], name: "index_products_on_shop_id", using: :btree
    t.index ["slug"], name: "index_products_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_products_on_user_id", using: :btree
  end

  create_table "ranks", force: :cascade do |t|
    t.integer  "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "score"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "referral_codes", force: :cascade do |t|
    t.string   "code"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "count"
    t.integer  "count_limit"
  end

  create_table "shops", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shops_on_user_id", using: :btree
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_ranks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "rank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_ratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "rating_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_referral_codes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "referral_code_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "publishable_key"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_code"
    t.string   "profile_name"
    t.string   "slug"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip_code"
    t.string   "paypal_email"
    t.boolean  "paypal_email_the_same"
    t.string   "stripe_user_id"
    t.string   "refresh_token"
    t.string   "access_token"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["profile_name"], name: "index_users_on_profile_name", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  end

  add_foreign_key "orders", "grouped_orders", column: "grouped_orders_id"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "shops"
  add_foreign_key "products", "users"
  add_foreign_key "shops", "users"
end
