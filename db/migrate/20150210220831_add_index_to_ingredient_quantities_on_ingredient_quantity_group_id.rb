class AddIndexToIngredientQuantitiesOnIngredientQuantityGroupId < ActiveRecord::Migration
  def change
    change_column :ingredient_quantities, :ingredient_quantity_group_id, :integer, :null => false
    add_index :ingredient_quantities, :ingredient_quantity_group_id
    remove_column :ingredient_quantities, :recipe_id
  end
end
