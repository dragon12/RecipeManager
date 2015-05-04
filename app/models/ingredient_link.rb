class IngredientLink < ActiveRecord::Base
  belongs_to :recipe_component, polymorphic: true
  belongs_to :ingredient, -> { joins(:ingredient_link).where(ingredient_links: {recipe_component_type: 'Ingredient'}) }, 
                              foreign_key: 'recipe_component_id'

  belongs_to :complex_ingredient, -> { joins(:ingredient_link).where(ingredient_links: {recipe_component_type: 'ComplexIngredient'}) }, 
                              foreign_key: 'recipe_component_id'
  
  belongs_to :ingredient_base
  
  delegate :name, :cost_for_quantity,
                  :kcal_for_quantity,
                  :measurement_type,
                  :measurement_type_str,
                  :cost_str,
                  :kcal_str,
                  :description_in_recipe,
                  :editable?,
                  :linkable?,
              :to => :recipe_component

  has_many :ingredient_quantities
  has_many :ingredient_quantity_groups, through: :ingredient_quantities
  has_many :recipes, through: :ingredient_quantity_groups
  
  validates :recipe_component, presence: true
  
  before_destroy :check_for_recipes
  
  def self.order_by_name
    IngredientLink.joins(:ingredient).order("ingredients.name") +
      IngredientLink.joins(complex_ingredient: :recipe).order("recipes.name")
  end
  
  def recipes_count
    recipes.distinct.count
  end
        
private

  def check_for_recipes
    if recipes.count > 0
      errors.add(:base, "Cannot delete ingredient while present in any recipes")
      return false
    end
  end
end
