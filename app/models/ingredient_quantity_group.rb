class IngredientQuantityGroup < ActiveRecord::Base
  
  belongs_to :recipe
  
  has_many :ingredient_quantities, -> {order(:created_at) }, dependent: :destroy
  accepts_nested_attributes_for :ingredient_quantities,
                      allow_destroy: true,
                      reject_if: lambda { |a| a[:quantity].blank? or (a[:ingredient].blank? and a[:ingredient_id].blank?) }
  
  #has_many :ingredients, through: :ingredient_quantities
  #accepts_nested_attributes_for :ingredients               

  validates_presence_of :ingredient_quantities

  validates :name, presence: true, length: {minimum: 2}
  
  
  def self.filter_blank_ingredient_quantities_from_group(group)
    #the hash has each key/val be an iq group
    
    empty = true
      
    if (group.has_key?("ingredient_quantities_attributes"))
      empty, insts = IngredientQuantity.filter_blank_from_ingredient_quantities(group["ingredient_quantities_attributes"])
    end
    
    if empty
      logger.info("  RECIPE_FILTER: group #{group[:name]} is empty, marking for destruction")
      group[:_destroy] = "1"
    end
    
    return group
  end
  
  
  def name_or_default
    name.blank? ? "<Enter Group Name>" : name
  end
  
  #def ingredient_quantities_attributes=(h)
  #  logger.info("Trying to set iq attribs to #{h}")
  #  debugger
  #  super(h)
  #end
  
  def cost
    total = 0
    ingredient_quantities.each do |iq|
      total += iq.cost
    end
    return total
  end
  
  def kcal
    total = 0
    ingredient_quantities.each do |iq|
      total += iq.kcal
    end
    return total
  end

end
