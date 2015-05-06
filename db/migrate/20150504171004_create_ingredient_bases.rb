class CreateIngredientBases < ActiveRecord::Migration
  def change
    
    create_table :ingredient_bases do |t|
      t.string :name
      t.timestamps
    end
    
    add_reference :ingredient_links, :ingredient_base, index: true

    #refresh the entire model
    ActiveRecord::Base.descendants.each{|c| c.reset_column_information}
    
    #now for each ingredient link, create the name in IngredientBase
    IngredientLink.all.each do |i|
      n = ""
      if i.recipe_component_type == 'Ingredient'
        n = Ingredient.connection.select_all("select i.name from ingredients i 
                                               join ingredient_links il on il.recipe_component_id = i.id
                                                                          and il.recipe_component_type = 'Ingredient'
                                               where il.id = #{i.id}").to_hash[0]["name"]
      else
        print "Looking up ingredient link #{i.inspect}"
        n = "Recipe: " + 
              Recipe.connection.select_all("select r.name from recipes r 
                        join complex_ingredients ci on ci.recipe_id = r.id
                        join ingredient_links il on il.recipe_component_id = ci.id and il.recipe_component_type = 'ComplexIngredient'
                        where il.id = #{i.id}").to_hash[0]["name"]
      end
      
      ib = IngredientBase.new(name: n)
      ib.save!
      
      i.ingredient_base = ib
      i.save!
    
    end
    
    #and now remove the name from the ingredients table
    remove_column :ingredients, :name
  end
end
