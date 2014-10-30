class IngredientQuantity < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :recipe
end
