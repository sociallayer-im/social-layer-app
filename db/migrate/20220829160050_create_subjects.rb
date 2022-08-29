class CreateSubjects < ActiveRecord::Migration[7.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :token_id
      t.text :content
      t.text :metadata
      t.string :owner_id
      t.datetime :created_at
    end
  end
end