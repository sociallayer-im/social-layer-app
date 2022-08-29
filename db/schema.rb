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

ActiveRecord::Schema[7.0].define(version: 2022_08_29_160109) do
  create_table "badge_templates", force: :cascade do |t|
    t.string "name"
    t.string "content"
    t.string "image_url"
    t.text "metadata"
    t.string "owner_id"
    t.datetime "created_at"
  end

  create_table "badges", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.string "title"
    t.text "metadata"
    t.text "content"
    t.string "image_url"
    t.string "signature"
    t.string "status", default: "new"
    t.string "token_id"
    t.integer "template_id"
    t.integer "subject_id"
    t.integer "org_id"
    t.string "issuer_id"
    t.string "receiver_id"
    t.string "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "profile_id"
    t.integer "org_id"
    t.datetime "created_at"
  end

  create_table "orgs", force: :cascade do |t|
    t.string "name"
    t.string "owner_id"
    t.string "image_url"
    t.text "content"
    t.text "metadata"
    t.datetime "created_at"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "address"
    t.string "username"
    t.string "domain"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "token_id"
    t.text "content"
    t.text "metadata"
    t.string "owner_id"
    t.datetime "created_at"
  end

end
