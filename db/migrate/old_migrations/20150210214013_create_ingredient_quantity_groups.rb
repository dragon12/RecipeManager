class CreateIngredientQuantityGroups < ActiveRecord::Migration
  def change
    add_column :ingredient_quantities, :ingredient_quantity_group_id, :integer
    
    create_table :ingredient_quantity_groups do |t|
      t.string :name
      t.belongs_to :recipe, index: true

      t.timestamps
    end
  end
end
