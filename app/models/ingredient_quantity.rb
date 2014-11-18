class IngredientQuantity < ActiveRecord::Base
  belongs_to :ingredient, :inverse_of => :ingredient_quantities
  belongs_to :recipe, :inverse_of => :ingredient_quantities
  
  #this is needed so that it can do fields_for on the nested ingredient
  accepts_nested_attributes_for :ingredient
  
  #validates :ingredient, :presence => true
  #validates :recipe, :presence => true
  
  validates :quantity, presence: true,
                 length: { minimum: 1 }
end
