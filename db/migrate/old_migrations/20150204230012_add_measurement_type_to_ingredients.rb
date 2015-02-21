class AddMeasurementTypeToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :measurement_type_id, :int
  end
end
