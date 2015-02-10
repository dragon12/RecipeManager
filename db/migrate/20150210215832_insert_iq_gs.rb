class InsertIqGs < ActiveRecord::Migration
  def change
    recipes = Recipe.all

    recipes.each do |r|
      iqg = IngredientQuantityGroup.new
      iqg.id = r.id
      iqg.name = "Ingredients"

      iqg.save

      r.ingredient_quantities.each do |iq|
        iq.ingredient_quantity_group_id = iq.recipe_id
        iq.save
      end
    end
  end
end
