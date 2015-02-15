class CreateInstructionGroups < ActiveRecord::Migration
  def change
    add_column :instructions, :instruction_group_id, :integer

    create_table :instruction_groups do |t|
      t.string :name
      t.belongs_to :recipe, index: true
      
      t.timestamps
    end
    
    Instruction.all.each do |i|
      i.instruction_group_id = i.recipe_id
      i.save!
    end
    
  end
end
