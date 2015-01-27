class AddDescriptionToLinks < ActiveRecord::Migration
  def change
    add_column :links, :description, :string
  end
end
