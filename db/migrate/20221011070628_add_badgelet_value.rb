class AddBadgeletValue < ActiveRecord::Migration[7.0]
  def change
    remove_column :badges, "value", :integer
    remove_column :badges, "last_consumed_at", :datetime

    add_column :badgelets, "value", :integer, default: 0
    add_column :badgelets, "last_consumed_at", :datetime

    add_column :badgelets, "presend_id", :integer
    add_column :presends, "counter", :integer, default: 1
  end
end
