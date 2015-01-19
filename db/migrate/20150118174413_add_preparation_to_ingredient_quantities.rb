class AddPreparationToIngredientQuantities < ActiveRecord::Migration
  def change
    add_column :ingredient_quantities, :preparation, :string
  end
end
