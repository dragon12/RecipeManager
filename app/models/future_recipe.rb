#coding: utf-8
class FutureRecipe < ActiveRecord::Base
  validates :name, presence: true
  validates :link, presence: true, uniqueness: true
  
  validate :valid_url, :link_not_in_recipes
  
  belongs_to :category
  validates :category, presence: true
  
      
  has_and_belongs_to_many :tags


  def get_link_source
    return URI.parse(link).host.sub(/\Awww\./, '')
  end
  

  def valid_url
    uri = URI.parse(link)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    errors.add(:link, "not valid")
  end

  def link_not_in_recipes
    links = Link.where("url = ?", link)
    if not links.empty?
      existing = links[0]
      logger.info("LINK: Found link already exists in recipe: #{links[0].recipe.name}")
      errors.add(:link, "Found link already exists in recipe: #{links[0].recipe.name}")
    end
  end
end
