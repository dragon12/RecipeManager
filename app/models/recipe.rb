class Recipe < ActiveRecord::Base
  has_many :ingredient_quantities
  has_many :instructions
  has_many :links
  
  validates_presence_of :name, :description
  
  validates :name, presence: true,
                   length: { minimum: 5 }
                    
end
