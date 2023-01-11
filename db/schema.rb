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

ActiveRecord::Schema[7.0].define(version: 2023_01_11_080748) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badge_collections", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.string "metadata"
    t.integer "owner_id"
    t.integer "badge_library_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "badge_libraries", force: :cascade do |t|
    t.string "title"
    t.integer "owner_id"
    t.string "image_url"
    t.string "content"
    t.string "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "badge_sets", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.string "title"
    t.text "metadata"
    t.text "content"
    t.string "image_url"
    t.integer "template_id"
    t.integer "subject_id"
    t.integer "org_id"
    t.string "issuer_id"
    t.integer "counter", default: 0
    t.datetime "created_at", null: false
  end

  create_table "badge_templates", force: :cascade do |t|
    t.string "name"
    t.string "content"
    t.string "image_url"
    t.text "metadata"
    t.string "owner_id"
    t.datetime "created_at"
  end

  create_table "badgelets", force: :cascade do |t|
    t.integer "index"
    t.integer "badge_id"
    t.integer "receiver_id"
    t.integer "owner_id"
    t.string "status", default: "new"
    t.text "metadata"
    t.string "subject_url"
    t.datetime "created_at"
    t.integer "sender_id"
    t.string "token_id"
    t.string "domain"
    t.text "content"
    t.integer "value", default: 0
    t.datetime "last_consumed_at"
    t.integer "presend_id"
    t.boolean "hide", default: false
    t.boolean "top", default: false
    t.string "hashtags", array: true
    t.string "chain_data"
  end

  create_table "badges", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.string "title"
    t.text "metadata"
    t.text "content"
    t.string "image_url"
    t.string "token_id"
    t.integer "template_id"
    t.integer "subject_id"
    t.integer "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sender_id"
    t.string "resource_type"
    t.string "resource_url"
    t.string "subject_url"
    t.string "badge_class"
    t.integer "badge_library_id"
    t.integer "badge_collection_id"
    t.string "unlocking"
    t.integer "counter", default: 1
    t.string "hashtags", array: true
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "source_id"
    t.integer "target_id"
    t.string "role"
    t.datetime "created_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.datetime "start_time"
    t.datetime "ending_time"
    t.string "location_type"
    t.string "location"
    t.integer "owner_id"
    t.integer "org_id"
    t.text "content"
    t.string "cover"
    t.string "status", default: "new", comment: "draft | open | closed | cancel"
    t.integer "max_participant"
    t.boolean "need_approval"
    t.string "host_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "tags", array: true
    t.string "online_location"
  end

  create_table "followings", force: :cascade do |t|
    t.integer "profile_id"
    t.integer "target_id"
    t.datetime "created_at"
    t.string "role"
  end

  create_table "mail_tokens", force: :cascade do |t|
    t.string "email"
    t.string "code"
    t.boolean "verified", default: false
    t.datetime "created_at", null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "profile_id"
    t.integer "org_id"
    t.datetime "created_at"
    t.string "role"
  end

  create_table "orgs", force: :cascade do |t|
    t.string "name"
    t.string "image_url"
    t.text "content"
    t.text "metadata"
    t.datetime "created_at"
    t.string "title"
    t.string "domain"
    t.integer "owner_id"
    t.string "token_id"
    t.index ["name"], name: "index_orgs_on_name", unique: true
  end

  create_table "participants", force: :cascade do |t|
    t.integer "profile_id"
    t.integer "event_id"
    t.text "message"
    t.datetime "check_time"
    t.string "status", default: "new", comment: "new | approved | disapproved | checked | cancel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "presends", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "badge_id"
    t.integer "badgelet_id"
    t.string "code"
    t.string "message"
    t.datetime "expires_at"
    t.boolean "accepted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "counter", default: 1
  end

  create_table "profiles", force: :cascade do |t|
    t.string "address"
    t.string "username"
    t.string "domain"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "address_type", default: "wallet"
    t.string "twitter"
    t.datetime "last_signin_at"
    t.string "permissions"
    t.string "token_id"
    t.string "twitter_proof_url"
    t.text "about"
    t.boolean "is_group"
    t.integer "group_owner_id"
    t.index ["address"], name: "index_profiles_on_address", unique: true
    t.index ["domain"], name: "index_profiles_on_domain", unique: true
    t.index ["username"], name: "index_profiles_on_username", unique: true
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "token_id"
    t.text "content"
    t.text "metadata"
    t.datetime "created_at"
    t.integer "owner_id"
    t.string "domain"
    t.string "title"
    t.string "subject_class"
    t.string "subject_url"
    t.string "hashtags"
  end

  create_table "template_collections", force: :cascade do |t|
    t.string "title"
    t.text "metadata"
    t.text "content"
    t.string "image_url"
    t.integer "template_library_id"
    t.integer "owner_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "template_libraries", force: :cascade do |t|
    t.string "title"
    t.text "metadata"
    t.text "content"
    t.string "image_url"
    t.integer "owner_id"
    t.string "license"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "title"
    t.text "metadata"
    t.text "content"
    t.string "image_url"
    t.string "resource_type"
    t.string "resource_url"
    t.integer "template_collection_id"
    t.integer "template_library_id"
    t.integer "owner_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
