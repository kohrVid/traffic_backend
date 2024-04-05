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

ActiveRecord::Schema[7.1].define(version: 2024_04_05_165801) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ip_infos", force: :cascade do |t|
    t.string "address"
    t.decimal "latitude"
    t.decimal "longitude"
    t.boolean "is_vpn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_ip_infos_on_address", unique: true
  end

  create_table "pages", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "registration_ip_info_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["registration_ip_info_id"], name: "index_users_on_registration_ip_info_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.bigint "page_id"
    t.bigint "user_id"
    t.datetime "visited_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ip_info_id"
    t.index ["ip_info_id"], name: "index_visits_on_ip_info_id"
    t.index ["page_id"], name: "index_visits_on_page_id"
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

  add_foreign_key "users", "ip_infos", column: "registration_ip_info_id"
  add_foreign_key "visits", "ip_infos"
  add_foreign_key "visits", "pages"
  add_foreign_key "visits", "users"
end
