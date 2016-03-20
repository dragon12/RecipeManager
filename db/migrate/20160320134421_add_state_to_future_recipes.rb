class AddStateToFutureRecipes < ActiveRecord::Migration
  def change
    add_column :future_recipes, :state, :int, :default => 0
  end
end
