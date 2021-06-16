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

ActiveRecord::Schema.define(version: 2021_06_10_083330) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "darjeelink_api_tokens", force: :cascade do |t|
    t.string "token", null: false
    t.string "username", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_darjeelink_api_tokens_on_token", unique: true
    t.index ["username"], name: "index_darjeelink_api_tokens_on_username", unique: true
  end

  create_table "darjeelink_short_links", force: :cascade do |t|
    t.string "url", null: false
    t.string "shortened_path"
    t.integer "visits", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((shortened_path)::text)", name: "index_darjeelink_short_links_on_lowercase_shortened_path", unique: true
    t.index ["url"], name: "index_darjeelink_short_links_on_url"
  end

end
