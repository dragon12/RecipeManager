class AddKcalBasisToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :kcal_basis, :integer
    Ingredient.connection.execute("update ingredients set kcal_basis = cost_basis")
  end
end
