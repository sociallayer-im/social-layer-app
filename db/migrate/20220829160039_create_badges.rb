class CreateBadges < ActiveRecord::Migration[7.0]
  def change
    create_table :badges do |t|
      t.string :name
      t.string :domain
      t.string :title
      t.text :metadata
      t.text :content
      t.string :image_url
      t.string :signature
      t.string :status, default: "new"
      t.string :token_id
      t.integer :template_id
      t.integer :subject_id
      t.integer :org_id
      t.string :issuer_id
      t.string :receiver_id
      t.string :owner_id
      t.timestamps
    end
  end
end