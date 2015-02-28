class CreateUserRatings < ActiveRecord::Migration
  def change
    create_table :user_ratings do |t|
      t.decimal :rating, precision: 10, scale: 2
      t.integer :user_id
      t.integer :recipe_id

      t.timestamps
    end
    add_index "user_ratings", ["user_id"], name: "index_user_ratings_on_user_id", using: :btree
    add_index "user_ratings", ["recipe_id"], name: "index_user_ratings_on_recipe_id", using: :btree

  end
end
