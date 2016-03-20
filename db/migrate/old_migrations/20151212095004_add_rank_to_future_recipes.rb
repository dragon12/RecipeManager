class AddRankToFutureRecipes < ActiveRecord::Migration
  def change
    add_column :future_recipes, :rank, :int, default: 0
  end
end
