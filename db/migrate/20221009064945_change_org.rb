class ChangeOrg < ActiveRecord::Migration[7.0]
  def change
    remove_column :orgs, "owner_id", :string
    add_column :orgs, "title", :string
    add_column :orgs, "domain", :string
    add_column :orgs, "owner_id", :integer
    add_column :memberships, "role", :string
  end
end
