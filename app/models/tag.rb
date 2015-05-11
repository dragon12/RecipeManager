class Tag < ActiveRecord::Base
  has_and_belongs_to_many :recipes
  
  before_destroy :check_for_recipes

private

  def check_for_recipes
    if recipes.count > 0
      errors.add(:base, "Cannot delete tag while used in any recipes")
      return false
    end
  end
end
