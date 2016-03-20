class AddIndexToLinkId < ActiveRecord::Migration
  def change
      add_index "ingredient_quantities", ["ingredient_link_id"], name: "index_ingredient_quantities_on_ingredient_link_id", using: :btree

  end
end
