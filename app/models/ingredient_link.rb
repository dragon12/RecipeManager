class IngredientLink < ActiveRecord::Base
  belongs_to :recipe_component, polymorphic: true

  delegate :name, :cost_for_quantity,
                  :kcal_for_quantity,
              :to => :recipe_component

  has_many :ingredient_quantities
  has_many :ingredient_quantity_groups, through: :ingredient_quantities
  has_many :recipes, through: :ingredient_quantity_groups
  
  validates :recipe_component, presence: true
  
  before_destroy :check_for_recipes

private

  def check_for_recipes
    if recipes.count > 0
      errors.add(:base, "Cannot delete ingredient while present in any recipes")
      return false
    end
  end
end
