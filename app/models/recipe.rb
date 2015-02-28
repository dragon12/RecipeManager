#coding: utf-8
class Recipe < ActiveRecord::Base
  belongs_to :category
  validates :category, presence: true
  
  has_many :ingredient_quantity_groups, -> {order(:created_at) }, dependent: :destroy
  accepts_nested_attributes_for :ingredient_quantity_groups, 
                    allow_destroy: true,
                    reject_if: lambda { |a| a[:name].blank? }
  
  has_many :ingredient_quantities, through: :ingredient_quantity_groups
  has_many :ingredients, through: :ingredient_quantities
  
  has_many :instruction_groups, -> {order(:created_at) }, dependent: :destroy
  accepts_nested_attributes_for :instruction_groups, allow_destroy: true
  
  has_many :instructions, through: :instruction_groups
  
  
  has_many :links, dependent: :destroy
  accepts_nested_attributes_for :links, 
                    #reject_if: lambda { |a| a[:url].blank? && a[:name].blank? },
                    allow_destroy: true
  
  validates_presence_of :description
  
  validates_presence_of :ingredient_quantity_groups
  
  validates :name, presence: true,
                   length: { minimum: 4 }



  validates :rating, :numericality => true, :allow_nil => true
  validates :portion_count, :numericality =>true, :allow_nil => true


  validate do
    logger.info "in validate now"
  end
  
  
  def cost_per_portion
    total = calculate_total_cost
    if portion_count.to_i == 0 || total == 0
      return "N/A"
    end
    
    per_portion = total / portion_count
    return "£%.2f" % per_portion
  end
  
  def kcal_per_portion
    total = calculate_total_kcal
    if portion_count.to_i == 0
      return "N/A"
    end
    return "%.0f" % (total / portion_count)
  end
  
  def total_cost
    total = calculate_total_cost
    if (total == 0)
      return "N/A"
    end
    return "£%.2f" % total
  end
  
  def total_kcal
    total = calculate_total_kcal
    if (total == 0)
      return "N/A"
    end
    return "%d" % total
  end
  
  def self.search_by_name(query)
    where("lower(name) like lower(?)", "%#{query}%") 
  end
  
  def self.search_by_ingredient(query)
    select("DISTINCT recipes.*")
      .joins(:ingredients)
      .where("lower(ingredients.name) like lower(?)", "%#{query}%")
  end
  
  def self.search_by_ingredient_id(query)
    select("DISTINCT recipes.*")
      .joins(:ingredients)
      .where("ingredients.id= ?", "#{query}")
  end

  def self.search_by_category_id(query)
    select("DISTINCT recipes.*")
      .joins(:category)
      .where("categories.id= ?", "#{query}")
  end
  
  def self.filter_blank_instructions_from_groups(hash)
    hash = hash.with_indifferent_access
    logger.info("\n\nRECIPE_FILTER_START")
    logger.info ("RECIPE_FILTER: working on #{hash.inspect}")
    #the hash has each key/val be an instruction group
    hash.each do |group_key, group|
      logger.info("  RECIPE_FILTER: looking at group #{group.inspect}")
      empty = true
      
      if (group.has_key?("instructions_attributes"))
        
        insts = group["instructions_attributes"]
             
        #strip any that are not real and are blank
        insts.reject! {|unused2, inst| Instruction.is_params_empty(inst) && inst["id"].blank?}
        insts.each do |unused2, inst|
          empty = false
          
          logger.info("    RECIPE_FILTER: looking at instruction #{inst}")
          if Instruction.is_params_empty(inst)
            logger.info("    RECIPE_FILTER: Is empty, marking for destruction")
            inst[:_destroy] = "1"
          end
        end
      end
      if empty
        logger.info("  RECIPE_FILTER: group #{group[:name]} is empty, marking for destruction")
        group[:_destroy] = "1"
      end
    end
    logger.info ("RECIPE_FILTER: returning #{hash.inspect}")
    
    return hash
  end
  
#  def ingredient_quantity_groups_attributes=(hash)
#    logger.info "setting iqd attributes: #{hash.inspect}"
#    hash.each do |seq, iqd_values|
#      if (!iqd_values["id"].blank?)
#        iqd = IngredientQuantityGroup.find(iqd_values["id"])
#      else
#        iqd = IngredientQuantityGroup.new(iqd_values)
#      end
#      logger.info "iqd values: #{iqd_values.inspect}"
#      iqd_values["ingredient_quantities_attributes"].each do |iq_seq, iq_values|
#      end
#      
#      ingredient_quantity_groups << iqd
#    end
#  end
#  
#  def ingredient_quantities_attributes=(hash)
#    logger.info "setting ingredient quantities: #{hash.inspect}"
#    logger.info "this recipe id is #{self.id}"
#    
#    hash.each do |sequence, ingredient_quantity_values|
#      #find the ingredient in question
#      logger.info "this: #{ingredient_quantity_values}"
#      
#      ingredient_id = 0;
#      if ingredient_quantity_values.has_key?("ingredient_name")
#        #ingredient_name = ingredient_quantity_values["ingredient_name"]
#        ingredient_id = Ingredient.find!(name: ingredient_quantity_values["ingredient_name"]).id
#      else
#        #ingredient_name = ingredient_quantity_values[:ingredient_attributes]["name"]
#        ingredient_id = ingredient_quantity_values["ingredient_id"]
#      end
#      
#      if ingredient_quantity_values[:_destroy] == "1"
#        unless ingredient_quantity_values["id"].blank?
#          self.ingredient_quantities.delete(ingredient_quantity_values["id"])
#        end
#        next
#      end
#      logger.info "ingredient id = #{ingredient_id}"
#      
#      i = Ingredient.find(ingredient_id)   
#      logger.info "ingredient name = #{i.name}"
#
#=begin     
#      begin
#        i = Ingredient.find_or_create_by!(name: ingredient_name)
#      rescue => e
#        logger.info "failed to do stuff: #{e.message}"
#        self.errors.add(:base, e.message)
#      end
#=end  
#      logger.info "i is now: #{i.inspect}"
#      
#      #for use in case of existing recipe: iq = IngredientQuantity.where()
#      # .. in which case we wouldn't add it to ingredient quantities directly
#      unless ingredient_quantity_values["id"].blank?
#        iq = IngredientQuantity.find(ingredient_quantity_values["id"])
#      else
#        iq = IngredientQuantity.new
#      end
#      
#      iq.ingredient = i
#      iq.quantity = ingredient_quantity_values[:quantity]
#      iq.preparation = ingredient_quantity_values[:preparation]
#      ingredient_quantities << iq
#      logger.info "iq is now: #{iq.inspect}"
#     
#    end
#  end
  
  private
  
  def calculate_total_cost
    cumulative = 0.0
    ingredient_quantity_groups.each do |iqd|
      cumulative += iqd.cost
    end
    return cumulative
  end
  
  
  def calculate_total_kcal
    cumulative = 0.0
    ingredient_quantity_groups.each do |iqd|
      cumulative += iqd.kcal
    end
    return cumulative
  end
  
end
