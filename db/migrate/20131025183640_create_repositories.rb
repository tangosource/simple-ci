class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :url
      t.integer :user_id
      t.boolean :activated

      t.timestamps
    end
  end
end