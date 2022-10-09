class CreateTemplateLibraries < ActiveRecord::Migration[7.0]
  def change
    create_table :template_libraries do |t|
      t.string "title"
      t.text "metadata"
      t.text "content"
      t.string "image_url"
      t.integer "owner_id"
      t.string "license"
      t.integer "price"
      t.timestamps
    end
  end
end
