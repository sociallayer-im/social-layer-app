class ChangeBadgeHashtags < ActiveRecord::Migration[7.0]
  def change
    remove_column :badges, :hashtags, :string
    add_column :badges, :hashtags, :string, array: true
    add_column :badgelets, :hashtags, :string, array: true
  end
end
