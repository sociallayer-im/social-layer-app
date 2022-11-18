class AddBadgeletDisplay < ActiveRecord::Migration[7.0]
  def change
    add_column :badgelets, :hide, :boolean, default: false
    add_column :badgelets, :top, :boolean, default: false
  end
end
