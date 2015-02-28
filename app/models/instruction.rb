class Instruction < ActiveRecord::Base
  belongs_to :instruction_group
  
  validates :step_number, presence: true,
                          numericality: { only_integer: true }
 
   
  validates :details, presence: true,
                      length: {minimum: 3}
                      

  #don't actually care if it's non-unique
  #validates_uniqueness_of :step_number, scope: :recipe_id
   
  before_destroy :on_destroy
  after_destroy :release_empty_parent

   
  
  def self.filter_blank_from_instructions(insts)
    #strip any that are not real and are blank
    insts.reject! {|unused2, inst| 
      is_params_empty(inst) && inst["id"].blank?
      }
    
    empty = true
    insts.each do |unused2, inst|
      empty = false
      
      logger.info("    RECIPE_FILTER: looking at instruction #{inst}")
      if is_params_empty(inst)
        logger.info("    RECIPE_FILTER: Is empty, marking for destruction")
        inst[:_destroy] = "1"
      end
    end
    
    return empty, insts
  end
  
private

  def self.is_params_empty(params)
    logger.info("Checking params for emptiness: #{params}")
    return params[:step_number].blank? && params[:details].blank?
  end
  
  
  def on_destroy
    logger.info("Starting destruction of instruction with parent #{instruction_group.name}")  
  end
  
  def release_empty_parent
    logger.info("After destroy")
    if instruction_group.instructions.count.zero?
      logger.warn("parent instruction group (#{instruction_group.name}) is now empty, destroying")
      instruction_group.destroy
    end
  end  
end
