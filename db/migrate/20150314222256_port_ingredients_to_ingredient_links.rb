class PortIngredientsToIngredientLinks < ActiveRecord::Migration
  def change
    add_column :ingredient_quantities, :ingredient_link_id, :integer

    ings = Ingredient.all
    ings.each do |i|
      
      print "looking at ingredient #{i.inspect}"
    
      il = IngredientLink.new(recipe_component_id: i.id, recipe_component_type: 'Ingredient')
      il.save!
      
      print "saved il: #{il.inspect}"
      
      iqs = i.ingredient_quantities
      iqs.each do |iq|
        print " IQ: #{iq.inspect}"
        iq.ingredient_link = il
        iq.save!
      end
    end
  end
end
