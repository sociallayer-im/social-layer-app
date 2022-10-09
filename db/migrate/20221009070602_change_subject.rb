class ChangeSubject < ActiveRecord::Migration[7.0]
  def change
    remove_column :subjects, "owner_id", :string
    add_column :subjects, "owner_id", :integer
    add_column :subjects, "domain", :string
    add_column :subjects, "title", :string
    add_column :subjects, "subject_class", :string
    add_column :subjects, "subject_url", :string
    add_column :subjects, "hashtags", :string
  end
end
