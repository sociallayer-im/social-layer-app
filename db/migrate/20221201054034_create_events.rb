class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_time
      t.datetime :ending_time
      t.string :location_type
      t.string :location
      t.integer :owner_id
      t.integer :org_id
      t.text :content
      t.string :cover
      t.string :status, default: "new", comment: "draft | open | closed | cancel"
      t.integer :max_participant
      t.boolean :need_approval
      t.string :host_info
      t.timestamps
    end
  end
end
