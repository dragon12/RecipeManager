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

  def cost_per_unit_str
    if cost_per_unit
      "%.2f" % cost_per_unit
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
