class IngredientQuantityGroup < ActiveRecord::Base
  before_destroy :check_for_ingredient_quantities
  
  belongs_to :recipe, :inverse_of => :ingredient_quantity_groups
  
  has_many :ingredient_quantities, -> {order(:created_at) }, dependent: :destroy
  accepts_nested_attributes_for :ingredient_quantities,
                      allow_destroy: true,
                      reject_if: lambda { |a| a[:quantity].blank? or a[:ingredient].blank? }
  
  has_many :ingredients, through: :ingredient_quantities
  accepts_nested_attributes_for :ingredients               

  validates_presence_of :ingredient_quantities

  validates :name, presence: true, length: {minimum: 2}
  
private
  def check_for_ingredient_quantities
    if ingredient_quantities.count > 0
      errors.add(:base, "Cannot delete ingredient quantity group while holding any ingredient quantity")
      return false
    end
  end
end
