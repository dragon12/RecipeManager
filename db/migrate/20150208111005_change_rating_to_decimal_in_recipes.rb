class ChangeRatingToDecimalInRecipes < ActiveRecord::Migration
  def change
       change_column :recipes, :rating,
    'numeric(10,2) USING CAST(rating AS numeric(10,2))'
  end
end
