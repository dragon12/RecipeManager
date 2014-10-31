class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.references :recipe, index: true

      t.timestamps
    end
  end
end
