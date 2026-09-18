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

ActiveRecord::Schema[8.1].define(version: 2026_09_17_233016) do
  create_table "branches", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "brands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
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
    t.integer "branch_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "km"
    t.decimal "price"
    t.datetime "updated_at", null: false
    t.boolean "used"
    t.integer "vehicle_model_id", null: false
    t.integer "year"
    t.index ["branch_id"], name: "index_vehicles_on_branch_id"
    t.index ["vehicle_model_id"], name: "index_vehicles_on_vehicle_model_id"
  end

  add_foreign_key "test_drives", "users"
  add_foreign_key "test_drives", "vehicles"
  add_foreign_key "vehicle_models", "brands"
  add_foreign_key "vehicles", "branches"
  add_foreign_key "vehicles", "vehicle_models"
end
