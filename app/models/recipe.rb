class Recipe < ActiveRecord::Base
  has_many :ingredient_quantities
  accepts_nested_attributes_for :ingredient_quantities, 
                    reject_if: lambda { |a| a[:quantity].blank? },
                    allow_destroy: true
                    
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
                    
end
