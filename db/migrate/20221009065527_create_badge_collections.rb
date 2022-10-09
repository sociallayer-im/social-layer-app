class CreateBadgeCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :badge_collections do |t|
      t.string :title
      t.string :content
      t.string :metadata
      t.integer :owner_id
      t.integer :badge_library_id
      t.timestamps
    end
  end
end
