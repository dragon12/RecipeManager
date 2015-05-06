#coding: utf-8
class ComplexIngredient < ActiveRecord::Base
  has_one :ingredient_link, as: :recipe_component, dependent: :destroy
  validates :ingredient_link, presence: true

  belongs_to :recipe
  validates :recipe, presence: true
  
  def editable?
    false
  end
  def linkable?
    true
  end
  def description_in_recipe
    name
  end
  
  def name
    return "Recipe: #{recipe.name}"
  end
  
  def cost_for_quantity(qty)
    return recipe.total_cost * qty.to_f
  end
  
  def kcal_for_quantity(qty)
    return recipe.total_kcal * qty.to_f
  end
  
  def measurement_type
    return MeasurementType.QuantityType
  end
  
  def measurement_type_str
    return measurement_type.measurement_type
  end
  
  def cost_str
    formatted_cost = "%.2f" % recipe.total_cost
    return "£#{formatted_cost}"
  end
  
  def kcal_str
    "%d" % recipe.total_kcal
  end
end
