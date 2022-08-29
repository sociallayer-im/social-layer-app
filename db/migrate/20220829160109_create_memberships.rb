class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.integer :profile_id
      t.integer :org_id
      t.datetime :created_at
    end
  end
end