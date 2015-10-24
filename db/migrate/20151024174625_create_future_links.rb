class CreateFutureLinks < ActiveRecord::Migration
  def change
    create_table :future_links do |t|
      t.string :name
      t.string :link, index: true
      t.string :description

      t.timestamps
    end
    
  create_table :future_links_tags, id: false do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :future_link, index: true
    end

  end
end
