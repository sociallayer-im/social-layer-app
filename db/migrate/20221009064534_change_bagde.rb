class ChangeBagde < ActiveRecord::Migration[7.0]
  def change
    remove_column :badges, "badge_set_id", :integer
    remove_column :badges, "issuer_id", :string
    remove_column :badges, "receiver_id", :string
    remove_column :badges, "owner_id", :string
    remove_column :badges, "signature", :string
    remove_column :badges, "status", :string

    add_column :badges, "sender_id", :integer
    add_column :badges, "counter", :integer
    add_column :badges, "resource_type", :string
    add_column :badges, "resource_url", :string
    add_column :badges, "subject_url", :string
    add_column :badges, "badge_class", :string
    add_column :badges, "hashtags", :string
  end
end
