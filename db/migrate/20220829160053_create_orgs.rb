class CreateOrgs < ActiveRecord::Migration[7.0]
  def change
    create_table :orgs do |t|
      t.string :name
      t.string :owner_id
      t.string :image_url
      t.text :content
      t.text :metadata
      t.datetime :created_at
    end
  end
end