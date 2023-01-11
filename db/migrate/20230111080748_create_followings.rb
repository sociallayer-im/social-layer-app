class CreateFollowings < ActiveRecord::Migration[7.0]
  def change
    create_table :followings do |t|
      t.integer "profile_id"
      t.integer "target_id"
      t.datetime "created_at"
      t.string "role"
    end
  end
end
