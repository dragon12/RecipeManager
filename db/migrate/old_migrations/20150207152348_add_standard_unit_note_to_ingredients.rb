class AddStandardUnitNoteToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :standard_unit_note, :string
  end
end
