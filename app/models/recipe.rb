class Recipe < ActiveRecord::Base
  has_many :ingredient_quantities
  accepts_nested_attributes_for :ingredient_quantities, 
                    reject_if: lambda { |a| a[:quantity].blank? },
                    allow_destroy: true
                    
  has_many :ingredients, through: :ingredient_quantities
                    
  has_many :instructions
  accepts_nested_attributes_for :instructions, 
                    reject_if: lambda { |a| a[:details].blank? },
                    allow_destroy: true
  
  has_many :links
  accepts_nested_attributes_for :links, 
                    reject_if: lambda { |a| a[:url].blank? },
                    allow_destroy: true
  
  validates_presence_of :name, :description
  
  validates :name, presence: true,
                   length: { minimum: 5 }

  def ingredient_quantities_attributes=(hash)
    logger.info "setting ingredient quantities: #{hash.inspect}"
    logger.info "this recipe id is #{self.id}"
    
    hash.each do |sequence, ingredient_quantity_values|
      #find the ingredient in question
      logger.info "this: #{ingredient_quantity_values}"
      
      i = Ingredient.find_or_create_by(name: ingredient_quantity_values[:quantity])
      logger.info "i is now: #{i.inspect}"
      #i = Ingredient.find_or_create_by(name: ingredient_quantity_values[:ingredient_name])
      #for use in case of existing recipe: iq = IngredientQuantity.where()
      # .. in which case we wouldn't add it to ingredient quantities directly
      iq = IngredientQuantity.new
      iq.ingredient = i
      #iq.recipe = self
      
      ingredient_quantities << iq
      logger.info "iq is now: #{iq.inspect}"
     
    end
    
  end
  
  private
  
end
