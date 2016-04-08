class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :blog_id

      t.timestamps null: false
    end
  end
end
