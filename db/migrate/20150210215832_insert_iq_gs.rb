class InsertIqGs < ActiveRecord::Migration
  def change
    recipes = Recipe.all

  IngredientQuantity.all.each do |iq|
        iq.ingredient_quantity_group_id = iq.recipe_id
        iq.save!
    end
      
    recipes.each do |r|
      iqg = IngredientQuantityGroup.new
      iqg.id = r.id
      iqg.recipe_id = r.id
      iqg.name = "Ingredients"
      
      
      iqg.save!
    end
    
  end
end
