class Category < ActiveRecord::Base
  has_many :recipes
  
  before_destroy :check_for_recipes

private

  def check_for_recipes
    if recipes.count > 0
      errors.add(:base, "Cannot delete category while used in any recipes")
      return false
    end
  end
end
