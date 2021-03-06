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

ActiveRecord::Schema.define(version: 2018_11_29_012056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", id: :string, limit: 42, force: :cascade do |t|
    t.string "street"
    t.string "city"
    t.string "neighborhood"
    t.string "county_code"
    t.decimal "latitude", precision: 20, scale: 15
    t.decimal "longitude", precision: 20, scale: 15
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "health_basic_unit_id", limit: 42
  end

  create_table "health_basic_units", id: :string, limit: 42, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "cnes_code"
  end

  create_table "scores", id: :string, limit: 42, force: :cascade do |t|
    t.integer "size"
    t.integer "adaptation_for_seniors"
    t.integer "medical_equipment"
    t.integer "medicine"
    t.string "health_basic_unit_id", limit: 42
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
