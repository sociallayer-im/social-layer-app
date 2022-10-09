class CreateBadgelets < ActiveRecord::Migration[7.0]
  def change
    create_table :badgelets do |t|
      t.integer "index"
      t.integer "badge_id"
      t.integer "receiver_id"
      t.integer "owner_id"
      t.string "status", default: "new"
      t.text "metadata"
      t.string "subject_url"
      t.datetime "created_at"
    end
  end
end
