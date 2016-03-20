class AddSlugToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :slug, :string
    add_index :recipes, :slug, unique: true
    
    Recipe.find_each(&:save)
  end
end
