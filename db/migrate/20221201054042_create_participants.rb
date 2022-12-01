class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.integer :profile_id
      t.integer :event_id
      t.text :message
      t.datetime :check_time
      t.string :status, default: "new", comment: "new | approved | disapproved | checked | cancel"
      t.timestamps
    end
  end
end
