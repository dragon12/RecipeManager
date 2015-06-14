class InstructionGroup < ActiveRecord::Base
  
  belongs_to :recipe
  has_many :instructions, -> {order(:step_number)}, dependent: :destroy
  
  accepts_nested_attributes_for :instructions, 
                                  allow_destroy: true
                                  #,
                                  #reject_if: lambda { |a| a[:step_number].blank? or a[:details].blank? }
  

  validates_presence_of :instructions
  validates :name, presence: true, length: {minimum: 2}

  def name_or_default
    name.blank? ? "<Enter Group Name>" : name
  end
  
  def self.filter_blank_instructions_from_group(group)
    #the hash has each key/val be an instruction group
    
    empty = true
      
    if (group.has_key?("instructions_attributes"))
      empty, insts = Instruction.filter_blank_from_instructions(group["instructions_attributes"])
    end
    
    if empty
      logger.info("  RECIPE_FILTER: group #{group[:name]} is empty, marking for destruction")
      group[:_destroy] = "1"
    end
    
    return group
  end
  
private
 
end
