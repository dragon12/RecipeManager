class RenameIngredientColumns < ActiveRecord::Migration
  def change
    rename_column :ingredients, :cost_per_unit_note, :cost_note
    rename_column :ingredients, :kcal_per_unit_note, :kcal_note
    remove_column :ingredients, :standard_unit_note
  end
end
