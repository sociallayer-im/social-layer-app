class AddBadgeBadgeSetId < ActiveRecord::Migration[7.0]
  def change
    add_column :badges, :badge_set_id, :integer
  end
end
