class LinkInstructionGroups < ActiveRecord::Migration
  def change
    Recipe.all.each do |r|
      if r.instructions.empty?
        next
      end
      ig = InstructionGroup.new
      ig.id = r.id
      ig.recipe_id = r.id
      ig.name = "Instructions"
      
      ig.save!
    end
  end
end
