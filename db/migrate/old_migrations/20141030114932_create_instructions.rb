class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.integer :step_number
      t.text :details
      t.belongs_to :recipe, index: true

      t.timestamps
    end
  end
end
