class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end
    
    create_table :recipes_tags, id: false do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :recipe, index: true
    end
  end
end
