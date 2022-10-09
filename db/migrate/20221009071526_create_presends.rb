class CreatePresends < ActiveRecord::Migration[7.0]
  def change
    create_table :presends do |t|
      t.integer "sender_id"
      t.integer "badge_id"
      t.integer "badgelet_id"
      t.string "code"
      t.string "message"
      t.datetime "expires_at"
      t.boolean "accepted", default: false
      t.timestamps
    end
  end
end
