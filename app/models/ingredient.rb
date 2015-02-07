#coding: utf-8
class Ingredient < ActiveRecord::Base
  belongs_to :measurement_type
  validates :measurement_type, presence: true
  
  has_many :ingredient_quantities
  has_many :recipes, through: :ingredient_quantities
  
  validates :name, presence: true,
                   length: { minimum: 3 },
                   uniqueness: { case_sensitive: false }
                   
                   
  validates :standard_unit, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :cost_per_unit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :kcal_per_unit, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  
  before_destroy :check_for_recipes

  def cost_for_quantity(qty)
    if standard_unit.to_i == 0 || cost_per_unit.nil?
        logger.error "CALC_COST: ingredient #{name} has zero values"
        return nil
      end
      
      logger.info "CALC_COST: ingredient #{name}, unit #{standard_unit}, cost #{cost_per_unit}"
      units_used = qty / standard_unit
      
      return units_used * cost_per_unit
  end
  
  def kcal_for_quantity(qty)
    if standard_unit.to_i == 0 || kcal_per_unit.nil?
        logger.error "CALC_KCAL: ingredient #{name} has zero values"
        return nil
      end
      
      logger.info "CALC_KCAL: ingredient #{name}, unit #{standard_unit}, kcal #{kcal_per_unit}"
      units_used = qty / standard_unit
      
      return units_used * kcal_per_unit
  end
  
  
  def standard_unit_str
    if !standard_unit_note.blank?
      "#{standard_unit} (#{standard_unit_note})"
    else
      "#{standard_unit}"
    end
  end
  
  def cost_per_unit_str
    formatted = ""
    if cost_per_unit
      formatted = "%.2f" % cost_per_unit
    end

    if !cost_per_unit_note.blank?
      "#{formatted} (#{cost_per_unit_note})"
    else
      "#{formatted}"
    end
  end

  def kcal_per_unit_str
    if !kcal_per_unit_note.blank?
      "#{kcal_per_unit} (#{kcal_per_unit_note})"
    else
      "#{kcal_per_unit}"
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
