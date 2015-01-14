class Instruction < ActiveRecord::Base
  belongs_to :recipe
  
  validates :step_number, presence: true,
                          numericality: { only_integer: true }
  
  validates :details, presence: true,
                      length: {minimum: 3}
                      
end
