class MeasurementType < ActiveRecord::Base
  has_many :ingredients
  before_destroy :check_for_ingredients

  validates :measurement_type, presence: true,
                              uniqueness: { case_sensitive: false }
 
  validates :measurement_name, uniqueness: { case_sensitive: false, :scope => :measurement_type }
 
private

  def check_for_ingredient
    if ingredient.count > 0
      errors.add(:base, "Cannot delete measurement type while used in any ingredient")
      return false
    end
  end
end

