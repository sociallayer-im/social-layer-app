class AddEventFields < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :category, :string
    add_column :events, :tags, :string, array: true
    add_column :events, :online_location, :string
  end
end
