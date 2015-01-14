class Instruction < ActiveRecord::Base
  belongs_to :recipe
  
  validates :step_number, presence: true
  
  validates :details, presence: true,
                      length: {minimum: 3}
                      
end
