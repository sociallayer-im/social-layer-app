class CreateBadgeSets < ActiveRecord::Migration[7.0]
  def change
    create_table :badge_sets do |t|
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
  end
end
