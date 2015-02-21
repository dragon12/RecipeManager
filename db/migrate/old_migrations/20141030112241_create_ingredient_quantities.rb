class CreateIngredientQuantities < ActiveRecord::Migration
  def change
    create_table :ingredient_quantities do |t|
      t.string :quantity
      t.belongs_to :ingredient, index: true
      t.belongs_to :recipe, index: true

      t.timestamps
    end
  end
end
