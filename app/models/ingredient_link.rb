class IngredientLink < ActiveRecord::Base
  belongs_to :recipe_component, polymorphic: true
  belongs_to :ingredient, -> { where(ingredient_links: {recipe_component_type: 'Ingredient'}) }, 
                              foreign_key: 'recipe_component_id'
  
  delegate :name, :cost_for_quantity,
                  :kcal_for_quantity,
                  :measurement_type,
                  :description_in_recipe,
              :to => :recipe_component

  has_many :ingredient_quantities
  has_many :ingredient_quantity_groups, through: :ingredient_quantities
  has_many :recipes, through: :ingredient_quantity_groups
  
  validates :recipe_component, presence: true
  
  before_destroy :check_for_recipes
  
  def self.order_by_name
    IngredientLink.joins(:ingredient).order("ingredients.name")
  end
                
private

  def check_for_recipes
    if recipes.count > 0
      errors.add(:base, "Cannot delete ingredient while present in any recipes")
      return false
    end
  end
end
