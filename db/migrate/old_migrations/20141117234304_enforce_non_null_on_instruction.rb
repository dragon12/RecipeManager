class EnforceNonNullOnInstruction < ActiveRecord::Migration
  def change
        change_column :instructions, 
                     :recipe_id, :integer, :null => false
                     
                     change_column :links, 
                     :recipe_id, :integer, :null => false
  end
end
