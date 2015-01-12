class IngredientQuantity < ActiveRecord::Base
  belongs_to :ingredient, :inverse_of => :ingredient_quantities
  belongs_to :recipe, :inverse_of => :ingredient_quantities
  
  #this is needed so that it can do fields_for on the nested ingredient
  accepts_nested_attributes_for :ingredient
  
  #validates :ingredient, :presence => true
  #validates :recipe, :presence => true
  
  def ingredient_name
    ingredient.try(:name)
  end
 
  def ingredient_name=(name)
    self.ingredient = Ingredient.find_or_create_by_name(name) if name.present?
  end

  validates :quantity, presence: true,
                 length: { minimum: 1 }
end
