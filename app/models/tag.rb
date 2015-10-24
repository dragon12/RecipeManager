class Tag < ActiveRecord::Base
  has_and_belongs_to_many :recipes
  has_and_belongs_to_many :future_recipes
  
  before_destroy :check_for_dependants

private

  def check_for_dependants
    if recipes.count > 0
      errors.add(:base, "Cannot delete tag while used in any recipes")
      return false
    end
    if future_recipes.count > 0
      errors.add(:base, "Cannot delete tag while used in any recipes")
      return false
    end
  end
end
