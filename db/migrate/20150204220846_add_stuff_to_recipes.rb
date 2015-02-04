class AddStuffToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :rating, :int
    add_column :recipes, :portion_count, :int
  end
end
