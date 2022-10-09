class CreateBadgeLibraries < ActiveRecord::Migration[7.0]
  def change
    create_table :badge_libraries do |t|
      t.string :title
      t.integer :owner_id
      t.string :image_url
      t.string :content
      t.string :metadata
      t.timestamps
    end
  end
end
