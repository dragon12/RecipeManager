#coding: utf-8
class Recipe < ActiveRecord::Base
  attr_accessor :is_recipe_component
  
  belongs_to :category
  validates :category, presence: true
  
  has_one :complex_ingredient, dependent: :destroy
  
  has_many :ingredient_quantity_groups, -> {order(:created_at) }, dependent: :destroy
  accepts_nested_attributes_for :ingredient_quantity_groups, 
                    allow_destroy: true,
                    reject_if: lambda { |a| a[:name].blank? }
  
  has_many :ingredient_quantities, through: :ingredient_quantity_groups
  has_many :ingredient_links, through: :ingredient_quantities
  has_many :simple_ingredients, through: :ingredient_links, 
                                source: :recipe_component, source_type: "Ingredient"
  has_many :ingredient_bases, through: :ingredient_links, source: :ingredient_base
                                

  has_many :instruction_groups, -> {order(:created_at) }, dependent: :destroy
  accepts_nested_attributes_for :instruction_groups, allow_destroy: true
  
  has_many :instructions, through: :instruction_groups
  
  
  has_many :links, dependent: :destroy
  accepts_nested_attributes_for :links, 
                    #reject_if: lambda { |a| a[:url].blank? && a[:name].blank? },
                    allow_destroy: true
  
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images,
                            allow_destroy: true
  
  
  validates_presence_of :description
  
  validates_presence_of :ingredient_quantity_groups
  
  validates :name, presence: true,
                   length: { minimum: 4 }



  validates :portion_count, :numericality =>true, :allow_nil => true

  has_many :user_ratings
  has_many :users, through: :user_ratings

  validate do
    logger.info "in validate now"
  end

  def sortable_name
    return name
  end
  
  def sortable_created_at
    return created_at
  end
  
  def average_rating
    avg = calc_average_rating
    if avg.nil?
      return "N/A"
    end
    
    return format_double(avg)
  end
  
  def is_recipe_component
    !complex_ingredient.nil?
  end
  
  def is_recipe_component=(value)
    logger.info("COMPLEX: YES? value = #{value}, complex = #{complex_ingredient.inspect}")
    if value == '1' && complex_ingredient.nil?
      ci = build_complex_ingredient
      ci.build_ingredient_link
      logger.info ("COMPLEX: Built complex: #{ci.inspect}")
    else
      if value == '0' && !complex_ingredient.blank?
        raise "Don't support this yet"
      end
    end 
  end
  
  def sortable_category
    return category.name
  end
  
  def sortable_average_rating
    avg = calc_average_rating
    if avg.nil?
      return -1
    end
    
    return avg
  end
  
  def sortable_rating_for_user(user)
    r = user_rating(user)
    if r.blank? || r.rating.blank?
      return -1
    end
    return r.rating
  end
  
  def rating_for_user(user)
    r = user_rating(user)
    if r.blank? || r.rating.blank?
      return "N/A"
    end
    return "%g" % r.rating.to_s
  end
  
  def user_rating(user)
    logger.debug("USER_RATING: looking for rating for user #{user.name}")
    rating = user_ratings.where(user_id: user.id).first
    logger.debug("USER_RATING: found #{rating.inspect})")
    return rating
  end
  
  def total_cost
    calculate_total_cost
  end
  
  def total_kcal
    calculate_total_kcal
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
  
  def total_cost_str
    total = calculate_total_cost
    if (total == 0)
      return "N/A"
    end
    return "£%.2f" % total
  end
  
  def total_kcal_str
    total = calculate_total_kcal
    if (total == 0)
      return "N/A"
    end
    return "%d" % total
  end
  
  def self.search_by_name(query)
    where("lower(name) like lower(?)", "%#{query}%") 
  end
  
  def self.search_by_ingredient_name(query)
    select("DISTINCT recipes.*")
      .joins(:ingredient_bases)
      .where("lower(ingredient_bases.name) like lower(?)", "%#{query}%")
  end
  
  def self.search_by_ingredient_base_id(query)
    select("DISTINCT recipes.*")
      .joins(:ingredient_bases)
      .where("ingredient_bases.id= ?", "#{query}")
  end

  def self.search_by_category_id(query)
    select("DISTINCT recipes.*")
      .joins(:category)
      .where("categories.id= ?", "#{query}")
  end
  
  def self.search_by_updated_since(d)
    Recipe.where("updated_at > ?", d)
  end
  
  
  def self.filter_blank_instructions_from_groups(hash)
    hash = hash.with_indifferent_access
    logger.info("\n\nRECIPE_FILTER_START")
    logger.info ("RECIPE_FILTER: working on #{hash.inspect}")
    #the hash has each key/val be an instruction group
    hash.each do |group_key, group|
      logger.info("  RECIPE_FILTER: looking at group #{group.inspect}")
      
      group = InstructionGroup.filter_blank_instructions_from_group(group)
    end
    
    logger.info ("RECIPE_FILTER: returning #{hash.inspect}")
    
    return hash
  end
  
  def self.filter_blank_ingredient_quantities_from_groups(hash)
    hash = hash.with_indifferent_access
    logger.info("\n\nRECIPE_FILTER_START")
    logger.info ("RECIPE_FILTER: working on #{hash.inspect}")
    #the hash has each key/val be an iq group
    hash.each do |group_key, group|
      logger.info("  RECIPE_FILTER: looking at group #{group.inspect}")
      
      group = IngredientQuantityGroup.filter_blank_ingredient_quantities_from_group(group)
    end
    
    logger.info ("RECIPE_FILTER: returning #{hash.inspect}")
    
    return hash
  end
    
private
  
  
  def format_double(input)
    if input.blank?
      return "N/A"
    end
    return "%g" % ("%.2f" % input.to_s)
  end
  
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
  
  
  def calc_average_rating
    sum = 0.0
    count = 0
    user_ratings.each do |ur|
      sum = sum + ur.rating
      count = count + 1
    end
    return count == 0 ? nil : (sum / count)
  end
  
  
end
