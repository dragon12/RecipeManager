#coding: utf-8
class FutureRecipe < ActiveRecord::Base
  validates :name, presence: true
  validates :link, presence: true, uniqueness: true
  
  validate :valid_url
  
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

end
