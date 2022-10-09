class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.string "title"
      t.text "metadata"
      t.text "content"
      t.string "image_url"
      t.string "resource_type"
      t.string "resource_url"
      t.integer "template_collection_id"
      t.integer "template_library_id"
      t.integer "owner_id"
      t.integer "position"
      t.timestamps
    end
  end
end
