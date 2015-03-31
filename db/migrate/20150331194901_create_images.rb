class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :description
      t.string :url
      t.belongs_to :recipe, index: true

      t.timestamps
    end
  end
end
