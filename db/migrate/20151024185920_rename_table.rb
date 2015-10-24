class RenameTable < ActiveRecord::Migration
  def change
                rename_table :future_links, :future_recipes
  end

end
