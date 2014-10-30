class Recipe < ActiveRecord::Base
  has_many :ingredient_quantities
  has_many :instructions
end
