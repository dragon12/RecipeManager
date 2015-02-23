class InstructionGroup < ActiveRecord::Base
  before_destroy :check_for_instructions
  
  belongs_to :recipe
  has_many :instructions, -> {order(:step_number)}, dependent: :destroy
  
  accepts_nested_attributes_for :instructions, 
                                  allow_destroy: true,
                                  reject_if: lambda { |a| a[:step_number].blank? or a[:details].blank? }
  
  validates_presence_of :instructions
  validates :name, presence: true, length: {minimum: 2}
  
  def name_or_default
    name.blank? ? "<Enter Group Name>" : name
  end
  
private
  def check_for_instructions
    if instructions.count > 0
      errors.add(:base, "Cannot delete instruction group while holding any instruction")
      return false
    end
  end
end
