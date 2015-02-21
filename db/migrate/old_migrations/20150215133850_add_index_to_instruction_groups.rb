class AddIndexToInstructionGroups < ActiveRecord::Migration
  def change
    change_column :instructions, :instruction_group_id, :integer, :null => false
    add_index :instructions, :instruction_group_id
  end
end
