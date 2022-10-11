class AddProfileOrgTokenId < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :token_id, :string
    add_column :orgs, :token_id, :string
  end
end
