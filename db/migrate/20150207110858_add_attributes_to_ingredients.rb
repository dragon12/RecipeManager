class AddAttributesToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :standard_unit, :int
    add_column :ingredients, :cost_per_unit, :decimal, :precision => 10, :scale => 2
    add_column :ingredients, :kcal_per_unit, :int
  end
end
