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

ActiveRecord::Schema[7.0].define(version: 2023_07_15_163022) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "behavior_occurrences", force: :cascade do |t|
    t.bigint "dog_id", null: false
    t.bigint "behavior_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "seen_on_date"
    t.float "amount", default: 0.0, null: false
    t.index ["behavior_id"], name: "index_behavior_occurrences_on_behavior_id"
    t.index ["dog_id"], name: "index_behavior_occurrences_on_dog_id"
  end

  create_table "behaviors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "dogs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "behavior_occurrences", "behaviors"
  add_foreign_key "behavior_occurrences", "dogs"
end
