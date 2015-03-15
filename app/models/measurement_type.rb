class MeasurementType < ActiveRecord::Base
  has_many :ingredients
  before_destroy :check_for_ingredients

  validates :measurement_type, presence: true,
                              uniqueness: { case_sensitive: false }
 
  validates :measurement_name, presence: true,
                               uniqueness: { case_sensitive: false}
 
  def self.QuantityType
    return MeasurementType.find_by(measurement_type: 'By Quantity')
  end
  
private

  def check_for_ingredients
    if ingredients.count > 0
      errors.add(:base, "Cannot delete measurement type while used in any ingredient")
      return false
    end
  end
end

