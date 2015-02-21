class AddIndexToIngredients < ActiveRecord::Migration
  def change
    add_index :ingredients, :measurement_type_id
  end
end
