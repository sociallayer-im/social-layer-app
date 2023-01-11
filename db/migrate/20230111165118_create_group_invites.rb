class CreateGroupInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :group_invites do |t|
      t.integer "sender_id"
      t.integer "group_id"
      t.integer "badge_id"
      t.string "message"
      t.datetime "expires_at"

      t.integer "presend_id"
      t.integer "receiver_id"
      t.integer "badgelet_id"
      t.boolean "accepted", default: false

      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
