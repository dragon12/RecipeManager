class IngredientBase < ActiveRecord::Base
  has_many :ingredient_links
  has_many :recipes, through: :ingredient_links
  
  validates :name, presence: true,
                   length: { minimum: 3 },
                   uniqueness: { case_sensitive: false }
                   
  before_destroy :check_for_ingredient_links
  auto_strip_attributes :name, :nullify => false, :squish => true
  
  def recipes_count
    recipes.distinct.count
  end
  
  def self.order_by_name
    simples_ordered_by_name + complex_ordered_by_name
  end
  
  def self.simples_ordered_by_name
    select("distinct ingredient_bases.*").joins(:ingredient_links).
            where("ingredient_links.recipe_component_type = 'Ingredient'").
            order("ingredient_bases.name")
  end
  
  def self.complex_ordered_by_name
    select("distinct ingredient_bases.*").joins(:ingredient_links).
            where("ingredient_links.recipe_component_type = 'ComplexIngredient'").
            order("ingredient_bases.name")
  end
private
  def check_for_ingredient_links
    if ingredient_links.count > 0
      errors.add(:base, "Cannot delete Ingredient Base while used in any Ingredient")
      return false
    end
  end
end
