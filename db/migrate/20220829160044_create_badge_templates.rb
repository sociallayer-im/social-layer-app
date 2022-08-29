class CreateBadgeTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :badge_templates do |t|
      t.string :name
      t.string :content
      t.string :image_url
      t.text :metadata
      t.string :owner_id
      t.datetime :created_at
    end
  end
end