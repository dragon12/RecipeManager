class Recipe < ActiveRecord::Base
  has_one :category
  
  has_many :ingredient_quantities, dependent: :destroy
  accepts_nested_attributes_for :ingredient_quantities, 
                    allow_destroy: true,
                    reject_if: lambda { |a| a[:quantity].blank? or a[:ingredient].blank? }
                    
  has_many :ingredients, through: :ingredient_quantities
  accepts_nested_attributes_for :ingredients               
                    
  has_many :instructions, -> { order(:step_number) },
            dependent: :destroy
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
  
  def self.search_by_name(query)
    where("name like ?", "%#{query}%") 
  end
  
  def self.search_by_ingredient(query)
    select("DISTINCT recipes.*")
      .joins(:ingredients)
      .where("ingredients.name like ?", "%#{query}%")
  end
  
  def self.search_by_ingredient_id(query)
    select("DISTINCT recipes.*")
      .joins(:ingredients)
      .where("ingredients.id= ?", "#{query}")
  end

  def ingredient_quantities_attributes=(hash)
    logger.info "setting ingredient quantities: #{hash.inspect}"
    logger.info "this recipe id is #{self.id}"
    
    hash.each do |sequence, ingredient_quantity_values|
      #find the ingredient in question
      logger.info "this: #{ingredient_quantity_values}"
      
      ingredient_id = 0;
      if ingredient_quantity_values.has_key?("ingredient_name")
        #ingredient_name = ingredient_quantity_values["ingredient_name"]
        ingredient_id = Ingredient.find!(name: ingredient_quantity_values["ingredient_name"]).id
      else
        #ingredient_name = ingredient_quantity_values[:ingredient_attributes]["name"]
        ingredient_id = ingredient_quantity_values["ingredient_id"]
      end
      
      if ingredient_quantity_values[:_destroy] == "1"
        unless ingredient_quantity_values["id"].blank?
          self.ingredient_quantities.delete(ingredient_quantity_values["id"])
        end
        next
      end
      logger.info "ingredient id = #{ingredient_id}"
      
      i = Ingredient.find(ingredient_id)   
      logger.info "ingredient name = #{i.name}"

=begin     
      begin
        i = Ingredient.find_or_create_by!(name: ingredient_name)
      rescue => e
        logger.info "failed to do stuff: #{e.message}"
        self.errors.add(:base, e.message)
      end
=end  
      logger.info "i is now: #{i.inspect}"
      
      #for use in case of existing recipe: iq = IngredientQuantity.where()
      # .. in which case we wouldn't add it to ingredient quantities directly
      unless ingredient_quantity_values["id"].blank?
        iq = IngredientQuantity.find(ingredient_quantity_values["id"])
      else
        iq = IngredientQuantity.new
      end
      
      iq.ingredient = i
      iq.quantity = ingredient_quantity_values[:quantity]
      iq.preparation = ingredient_quantity_values[:preparation]
      ingredient_quantities << iq
      logger.info "iq is now: #{iq.inspect}"
     
    end
  end
  
  private
  
end
