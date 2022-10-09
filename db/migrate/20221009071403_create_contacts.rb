class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.integer "source_id"
      t.integer "target_id"
      t.string "role"
      t.datetime "created_at", null: false
    end
  end
end
