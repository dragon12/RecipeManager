#coding: utf-8
class Ingredient < ActiveRecord::Base
  belongs_to :measurement_type
  validates :measurement_type, presence: true
  
  has_many :ingredient_quantities
  has_many :recipes, through: :ingredient_quantities
  
  validates :name, presence: true,
                   length: { minimum: 3 },
                   uniqueness: { case_sensitive: false }
                   
                   
  validates :cost_basis, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :kcal_basis, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :kcal, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  
  before_destroy :check_for_recipes

  def cost_for_quantity(qty)
    if cost_basis.to_i == 0 || cost.nil?
        logger.error "CALC_COST: ingredient #{name} has zero values"
        return nil
      end
      
      logger.info "CALC_COST: ingredient #{name}, unit #{cost_basis}, cost #{cost}"
      units_used = qty / cost_basis
      
      return units_used * cost
  end
  
  def kcal_for_quantity(qty)
    if kcal_basis.to_i == 0 || kcal.nil?
        logger.error "CALC_KCAL: ingredient #{name} has zero values"
        return nil
      end
      
      logger.info "CALC_KCAL: ingredient #{name}, unit #{kcal_basis}, kcal #{kcal}"
      units_used = qty / kcal_basis
      
      return units_used * kcal
  end
  
  def measurement_type_str
    measurement_type ? measurement_type.measurement_type : "N/A"
  end
  
  def basis_str(basis)
    if measurement_type.measurement_type == "By Quantity"
      if basis == 1
        return " each"
      else
        return " for #{basis}"
      end
    end
    return " / #{basis}#{measurement_type.measurement_name}"
  end
  
  def cost_str
    if cost > 0
      formatted_cost = "%.2f" % cost
    
      formatted = "#{formatted_cost}#{basis_str(cost_basis)}"
    else
      formatted = "0"
    end
    
    if !cost_note.blank?
      return "£#{formatted} (#{cost_note})"
    else
      return "£#{formatted}"
    end
  end

  def kcal_str
    if kcal > 0
      formatted = "#{kcal}#{basis_str(kcal_basis)}"
    else
      formatted = "0"
    end
    
    if !kcal_note.blank?
      return "#{formatted} (#{kcal_note})"
    else
      return "#{formatted}"
    end
  end
  
  
  def description_in_recipe
    if !measurement_type.measurement_name.blank?
      "#{name} (#{measurement_type.measurement_name})"
    else
      "#{name}"
    end
  end
private

  def check_for_recipes
    if recipes.count > 0
      errors.add(:base, "Cannot delete ingredient while present in any recipes")
      return false
    end
  end
end
