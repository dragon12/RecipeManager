class CreateIngredientLinks < ActiveRecord::Migration
  def change
    create_table :ingredient_links do |t|
      t.references :recipe_component, polymorphic: true
      t.timestamps
      
      t.index([:recipe_component_id, :recipe_component_type], unique: true, 
                name: 'ingredient_links_link_index')
    end
  end
end
