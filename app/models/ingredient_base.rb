class IngredientBase < ActiveRecord::Base
  has_many :ingredient_links
  
  validates :name, presence: true,
                   length: { minimum: 3 },
                   uniqueness: { case_sensitive: false }
                   
  before_destroy :check_for_ingredient_links
  
private
  def check_for_ingredient_links
    if ingredient_links.count > 0
      errors.add(:base, "Cannot delete Ingredient Base while used in any Ingredient")
      return false
    end
  end
end
