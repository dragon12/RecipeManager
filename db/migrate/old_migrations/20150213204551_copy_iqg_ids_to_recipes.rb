class CopyIqgIdsToRecipes < ActiveRecord::Migration
  def change
    IngredientQuantityGroup.all.each do |iqd|
      iqd.recipe_id = iqd.id
      iqd.save
    end
  end
end
