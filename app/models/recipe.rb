class Recipe < ActiveRecord::Base
  has_many :ingredient_quantities, dependent: :destroy
  accepts_nested_attributes_for :ingredient_quantities, 
                    allow_destroy: true,
                    reject_if: lambda { |a| a[:quantity].blank? or a[:ingredient].blank? }
                    
  has_many :ingredients, through: :ingredient_quantities
  accepts_nested_attributes_for :ingredients               
                    
  has_many :instructions, dependent: :destroy
  accepts_nested_attributes_for :instructions, 
                    reject_if: lambda { |a| a[:details].blank? },
                    allow_destroy: true
  
  has_many :links, dependent: :destroy
  accepts_nested_attributes_for :links, 
                    reject_if: lambda { |a| a[:url].blank? },
                    allow_destroy: true
  
  validates_presence_of :description, :ingredient_quantities
  
  validates :name, presence: true,
                   length: { minimum: 5 }

  validate do
    logger.info "in validate now"
  end
  
  def ingredient_quantities_attributes=(hash)
    logger.info "setting ingredient quantities: #{hash.inspect}"
    logger.info "this recipe id is #{self.id}"
    
    hash.each do |sequence, ingredient_quantity_values|
      #find the ingredient in question
      logger.info "this: #{ingredient_quantity_values}"
      
      ingredient_attribs = ingredient_quantity_values[:ingredient]
      logger.info "ingredient_attribs = #{ingredient_attribs}"
      
      next if ingredient_quantity_values[:_destroy] == "1"
       
      logger.info "ingredient name = #{ingredient_attribs[:name]}"
      
      begin
        i = Ingredient.find_or_create_by!(name: ingredient_attribs["name"])
      rescue => e
        logger.info "failed to do stuff: #{e.message}"
        self.errors.add(:base, e.message)
      end
        
      logger.info "i is now: #{i.inspect}"
      
      #for use in case of existing recipe: iq = IngredientQuantity.where()
      # .. in which case we wouldn't add it to ingredient quantities directly
      iq = IngredientQuantity.new
      iq.ingredient = i
      iq.quantity = ingredient_quantity_values[:quantity]
      ingredient_quantities << iq
      logger.info "iq is now: #{iq.inspect}"
     
    end
  end
  
  private
  
end
