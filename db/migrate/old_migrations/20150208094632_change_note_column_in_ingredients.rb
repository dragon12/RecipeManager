class ChangeNoteColumnInIngredients < ActiveRecord::Migration
  def change
    rename_column :ingredients, :standard_unit, :cost_basis
  end
end
