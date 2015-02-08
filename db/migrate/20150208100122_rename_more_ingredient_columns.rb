class RenameMoreIngredientColumns < ActiveRecord::Migration
  def change
    rename_column :ingredients, :cost_per_unit, :cost
    rename_column :ingredients, :kcal_per_unit, :kcal
  end
end
