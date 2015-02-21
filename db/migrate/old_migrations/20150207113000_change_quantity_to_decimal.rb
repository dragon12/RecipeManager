class ChangeQuantityToDecimal < ActiveRecord::Migration
  def change
    change_column :ingredient_quantities, :quantity,
    'numeric(10,3) USING CAST(quantity AS numeric(10,3))'
  end
end
