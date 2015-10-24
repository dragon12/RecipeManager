class AddCategory < ActiveRecord::Migration
  def change
    add_column :future_recipes, :category_id, :int
    add_index :future_recipes, :category_id
  end
end
