class Instruction < ActiveRecord::Base
  belongs_to :instruction_group
  
  validates :step_number, presence: true,
                          numericality: { only_integer: true }
  
  validates :details, presence: true,
                      length: {minimum: 3}
                      
  #don't actually care if it's non-unique
  #validates_uniqueness_of :step_number, scope: :recipe_id
                      
end
