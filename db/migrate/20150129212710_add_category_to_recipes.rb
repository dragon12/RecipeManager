class AddCategoryToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :category_id, :int
  end
end
