#coding: utf-8
class IngredientQuantity < ActiveRecord::Base
  belongs_to :ingredient, :inverse_of => :ingredient_quantities
  belongs_to :recipe, :inverse_of => :ingredient_quantities
  
  #this is needed so that it can do fields_for on the nested ingredient
  accepts_nested_attributes_for :ingredient
  
  #validates :ingredient, :presence => true
  #validates :recipe, :presence => true
  @cost_for_qty = nil
  
  def cost_for_qty
    @cost_for_qty
  end
  
  def cost_for_qty=(cost)
    @cost_for_qty = cost
  end
  
  @kcal_for_qty = nil
  
  def kcal_for_qty
    @kcal_for_qty
  end
  
  def kcal_for_qty=(kcal)
    @kcal_for_qty = kcal
  end
  
  def cost
    if cost_for_qty.nil?
      cost_for_qty = ingredient.cost_for_quantity(quantity)
    end
    
    return cost_for_qty
  end
  
  def kcal
    if kcal_for_qty.nil?
      kcal_for_qty = ingredient.kcal_for_quantity(quantity)
    end
    
    return kcal_for_qty
  end
  
  def quantity_as_string
    if self.quantity
      "%g" % self.quantity
    end
  end
  
  def cost_as_str
    c = cost
    if c.nil?
      return "N/A"
    end
    return "£%.2f" % c
  end
  
  def kcal_as_str
    k = kcal
    if k.nil?
      return "N/A"
    end
    return "%.0f"% k
  end
  
  def quantity_description
    measurement = self.ingredient.measurement_type.measurement_name
    if measurement.blank?
      "#{quantity_as_string}"
    else
      "#{quantity_as_string} #{measurement}"
    end
  end
  
  def prepared_ingredient_description
    prep = preparation.blank? ? "" : ", #{preparation}"
    return "#{ingredient.name}#{prep}"
  end
  
  def ingredient_name
    ingredient.try(:name)
  end
 
  def ingredient_name=(name)
    self.ingredient = Ingredient.find_or_create_by_name(name) if name.present?
  end

  validates :quantity, presence: true, numericality: true
end
