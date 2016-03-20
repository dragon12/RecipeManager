class TidyIngredientQuantities < ActiveRecord::Migration
  def change
    change_column :ingredient_quantities, :ingredient_link_id, :integer, :null => false
    remove_column :ingredient_quantities, :ingredient_id    
  end
end
