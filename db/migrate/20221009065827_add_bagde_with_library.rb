class AddBagdeWithLibrary < ActiveRecord::Migration[7.0]
  def change
    add_column :badges, :badge_library_id, :integer
    add_column :badges, :badge_collection_id, :integer
  end
end
