class AddBadgeletSenderId < ActiveRecord::Migration[7.0]
  def change
    add_column :badgelets, :sender_id, :integer
    add_column :badgelets, :token_id, :string
    add_column :badgelets, :domain, :string
    add_column :badgelets, :content, :text
    remove_column :badges, :counter, :integer
    add_column :badges, :counter, :integer, default: 1
  end
end
