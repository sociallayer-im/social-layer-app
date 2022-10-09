class ChangeProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, "address_type", :string, default: "wallet"
    add_column :profiles, "twitter", :string
    add_column :profiles, "last_signin_at", :datetime
    add_column :profiles, "permissions", :string

    add_column :badges, "value", :integer
    add_column :badges, "last_consumed_at", :datetime
    add_column :badges, "unlocking", :string
  end
end
