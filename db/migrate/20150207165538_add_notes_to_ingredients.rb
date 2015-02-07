class AddNotesToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :cost_per_unit_note, :string
    add_column :ingredients, :kcal_per_unit_note, :string
  end
end
