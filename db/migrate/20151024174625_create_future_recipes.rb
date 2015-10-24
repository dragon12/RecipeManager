class CreateFutureLinks < ActiveRecord::Migration
  def change
    create_table :future_recipes do |t|
      t.string :name
      t.string :link, index: true
      t.string :description
      t.int    :category_id
      t.timestamps
    end

    add_index :future_recipes, :category_id

  create_table :future_recipes_tags, id: false do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :future_recipe, index: true
    end

  end
end
