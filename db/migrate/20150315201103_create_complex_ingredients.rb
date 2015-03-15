class CreateComplexIngredients < ActiveRecord::Migration
  def change
    create_table :complex_ingredients do |t|
      t.integer :recipe_id

      t.timestamps     
      
    end
    
    add_index "complex_ingredients", ["recipe_id"], name: "index_complex_ingredients_on_recipe_id", using: :btree

  end
end
