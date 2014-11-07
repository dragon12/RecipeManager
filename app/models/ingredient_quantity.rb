class IngredientQuantity < ActiveRecord::Base
  belongs_to :ingredient, :inverse_of => :ingredient_quantities
  belongs_to :recipe, :inverse_of => :ingredient_quantities
  
  #validates :ingredient, :presence => true
  #validates :recipe, :presence => true
  
  validates :quantity, presence: true,
                 length: { minimum: 1 }
end
