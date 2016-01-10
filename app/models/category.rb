class Category < ActiveRecord::Base
  has_many :recipes
  has_many :future_recipes

  auto_strip_attributes :name, :nullify => false, :squish => true
  
  before_destroy :check_for_dependants


private

  def check_for_dependants
    if recipes.count > 0
      errors.add(:base, "Cannot delete category while used in any recipes")
      return false
    end
    if future_recipes.count > 0
      errors.add(:base, "Cannot delete category while used in any future recipes")
      return false
    end
  end
end
