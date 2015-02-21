class AddCommentToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :comments, :text
  end
end
