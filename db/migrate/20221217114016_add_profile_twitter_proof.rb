class AddProfileTwitterProof < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :twitter_proof_url, :string
    add_column :badgelets, :chain_data, :string
  end
end
