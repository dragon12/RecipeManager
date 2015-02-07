# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150207152348) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredient_quantities", force: true do |t|
    t.decimal  "quantity",      precision: 10, scale: 3
    t.integer  "ingredient_id",                          null: false
    t.integer  "recipe_id",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "preparation"
  end

  add_index "ingredient_quantities", ["ingredient_id"], name: "index_ingredient_quantities_on_ingredient_id", using: :btree
  add_index "ingredient_quantities", ["recipe_id"], name: "index_ingredient_quantities_on_recipe_id", using: :btree

  create_table "ingredients", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "measurement_type_id"
    t.integer  "standard_unit"
    t.decimal  "cost_per_unit",       precision: 10, scale: 2
    t.integer  "kcal_per_unit"
    t.string   "standard_unit_note"
  end

  add_index "ingredients", ["measurement_type_id"], name: "index_ingredients_on_measurement_type_id", using: :btree

  create_table "instructions", force: true do |t|
    t.integer  "step_number"
    t.text     "details"
    t.integer  "recipe_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instructions", ["recipe_id"], name: "index_instructions_on_recipe_id", using: :btree

  create_table "links", force: true do |t|
    t.string   "url"
    t.integer  "recipe_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "links", ["recipe_id"], name: "index_links_on_recipe_id", using: :btree

  create_table "measurement_types", force: true do |t|
    t.string   "measurement_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "measurement_name"
  end

  create_table "recipes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.text     "comments"
    t.integer  "category_id"
    t.string   "total_time"
    t.string   "active_time"
    t.string   "cooking_time"
    t.integer  "rating"
    t.integer  "portion_count"
  end

  add_index "recipes", ["category_id"], name: "index_recipes_on_category_id", using: :btree

end
