#coding: utf-8
class Ingredient < ActiveRecord::Base
  has_one :ingredient_link, as: :recipe_component, dependent: :destroy, autosave: true
  validates :ingredient_link, presence: true
  
  belongs_to :measurement_type
  validates :measurement_type, presence: true
  
  has_one :ingredient_base, through: :ingredient_link
  
  has_many :ingredient_quantities, through: :ingredient_link
  has_many :ingredient_quantity_groups, through: :ingredient_quantities
  has_many :recipes, through: :ingredient_quantity_groups
  
  after_destroy :release_unused_base
                    
                   
  validates :cost_basis, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :kcal_basis, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :kcal, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  def editable?
    true
  end
  def linkable?
    false
  end
  
  #used during construction - map to the ingredient base
  def name=(n)
    logger.info "HELLO"
    self.ingredient_base = IngredientBase.find_or_create_by!(name: n)
    logger.info "ingredient base is now #{ingredient_base.inspect}"
  end
  
  def name
    logger.info "ingredient base getter is now #{ingredient_base.inspect}"
    return self.ingredient_base.name
  end
  
  def cost_for_quantity(qty)
    if cost_basis.to_i == 0 || cost.nil?
        logger.error "CALC_COST: ingredient #{name} has zero values"
        return 0
      end
      
      logger.info "CALC_COST: ingredient #{name}, unit #{cost_basis}, cost #{cost}"
      units_used = qty / cost_basis.to_f
      
      return units_used * cost
  end
  
  def kcal_for_quantity(qty)
    if kcal_basis.to_i == 0 || kcal.nil?
        logger.error "CALC_KCAL: ingredient #{name} has zero values"
        return 0
      end
      
      logger.info "CALC_KCAL: ingredient #{name}, unit #{kcal_basis}, kcal #{kcal}"
      units_used = qty / kcal_basis.to_f
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
    
  def release_unused_base
    logger.info("After ingredient destroy")
    if ingredient_base.ingredients.count.zero?
      logger.warn("base ingredient is now unused, destroying")
      ingredient_base.destroy
    end
  end            
  
end
