class AddProfileGroupInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :about, :text
    add_column :profiles, :is_group, :boolean
    add_column :profiles, :group_owner_id, :integer
  end
end
