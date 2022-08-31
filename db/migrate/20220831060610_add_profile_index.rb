class AddProfileIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :profiles, :address, unique: true
    add_index :profiles, :username, unique: true
    add_index :profiles, :domain, unique: true
    add_index :orgs, :name, unique: true
  end
end
