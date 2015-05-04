class CreateIngredientBases < ActiveRecord::Migration
  def change
    
    create_table :ingredient_bases do |t|
      t.string :name
      t.timestamps
    end
    
    add_reference :ingredient_links, :ingredient_base, index: true

    #refresh the entire model
    ActiveRecord::Base.descendants.each{|c| c.reset_column_information}
    
    #now for each ingredient link, create the name in IngredientBase
    IngredientLink.all.each do |i|
      ib = IngredientBase.new(name: i.name)
      ib.save!
      
      i.ingredient_base = ib
      i.save!
    
    end
    
    #and now remove the name from the ingredients table
    remove_column :ingredients, :name
  end
end
