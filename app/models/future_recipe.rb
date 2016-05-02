#coding: utf-8
class FutureRecipe < ActiveRecord::Base
  validates :name, presence: true
  validates :link, presence: true, uniqueness: true
  
  validate :valid_url, :link_not_in_recipes
  
  belongs_to :category
  validates :category, presence: true
  
      
  has_and_belongs_to_many :tags

  auto_strip_attributes :name, :link, :description, :nullify => false, :squish => true

  enum state: [ :pending, :done, :discarded ]

  def get_link_source
    return URI.parse(link).host.sub(/\Awww\./, '')
  end
  
  def get_state
    logger.info("state is now #{state}")
    state or "UNKNOWN"
  end

  def valid_url
    uri = URI.parse(link)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    errors.add(:link, "not valid")
  end

  def link_not_in_recipes
    if self.persisted?
      return
    end
    
    links = Link.where("url = ?", link)
    if not links.empty?
      existing = links[0]
      logger.info("LINK: Found link already exists in recipe: #{links[0].recipe.name}")
      errors.add(:link, "Found link already exists in recipe: #{links[0].recipe.name}")
    end
  end
  
  
  def sortable_name
    return name
  end
  
  def sortable_category
    return category.name
  end
  
  def sortable_updated_at
    return updated_at
  end

  def sortable_created_at
    return created_at
  end
  
  def sortable_website
    return get_link_source()
  end

  def sortable_rank
    return rank
  end
  
  def self.search_by_name(query)
    where("lower(name) like lower(?)", "%#{query}%") 
  end
  
  def self.search_by_category_id(query)
    select("DISTINCT future_recipes.*")
      .joins(:category)
      .where("categories.id= ?", "#{query}")
  end
  
  def self.search_by_website(query)
    where("link like ?", "%#{query}%")
    #initial = where("link like ?", "%#{query}%")
    #initial.select{|fr| fr.get_link_source =~ /#{query}/}
  end
  
  
end
