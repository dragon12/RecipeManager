class AddTimesToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :total_time, :string
    add_column :recipes, :active_time, :string
    add_column :recipes, :cooking_time, :string
  end
end
