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

ActiveRecord::Schema[8.1].define(version: 2026_09_24_182401) do
  create_table "brands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "sales", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency", default: "ars", null: false
    t.integer "customer_id", null: false
    t.text "notes"
    t.string "payment_method", default: "cash", null: false
    t.decimal "price", precision: 14, scale: 2, null: false
    t.integer "seller_id", null: false
    t.date "sold_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vehicle_id", null: false
    t.index ["customer_id"], name: "index_sales_on_customer_id"
    t.index ["seller_id"], name: "index_sales_on_seller_id"
    t.index ["vehicle_id"], name: "index_sales_on_vehicle_id", unique: true
  end

  create_table "test_drives", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "scheduled_date"
    t.time "scheduled_time"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "vehicle_id", null: false
    t.index ["user_id"], name: "index_test_drives_on_user_id"
    t.index ["vehicle_id"], name: "index_test_drives_on_vehicle_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.integer "role"
    t.datetime "updated_at", null: false
  end

  create_table "vehicle_models", force: :cascade do |t|
    t.integer "brand_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_vehicle_models_on_brand_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency", default: "ars", null: false
    t.text "description"
    t.integer "km"
    t.decimal "price"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.boolean "used"
    t.integer "vehicle_model_id", null: false
    t.integer "year"
    t.index ["status"], name: "index_vehicles_on_status"
    t.index ["vehicle_model_id"], name: "index_vehicles_on_vehicle_model_id"
  end

  add_foreign_key "sales", "users", column: "customer_id"
  add_foreign_key "sales", "users", column: "seller_id"
  add_foreign_key "sales", "vehicles"
  add_foreign_key "test_drives", "users"
  add_foreign_key "test_drives", "vehicles"
  add_foreign_key "vehicle_models", "brands"
  add_foreign_key "vehicles", "vehicle_models"
end
