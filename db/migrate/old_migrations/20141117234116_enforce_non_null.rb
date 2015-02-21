class EnforceNonNull < ActiveRecord::Migration
  def change
    change_column :ingredient_quantities, 
                     :ingredient_id, :integer, :null => false
                     
    change_column :ingredient_quantities, 
                     :recipe_id, :integer, :null => false

  end
end
