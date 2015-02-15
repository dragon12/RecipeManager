class RemoveRecipeIdFromInstructions < ActiveRecord::Migration
  def change
    remove_column :instructions, :recipe_id
  end
end
