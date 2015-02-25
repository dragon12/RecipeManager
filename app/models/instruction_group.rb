class InstructionGroup < ActiveRecord::Base
  
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
 
end
