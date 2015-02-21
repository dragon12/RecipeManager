class PortNotesToCostNotes < ActiveRecord::Migration
  def change
    Ingredient.connection.execute("update ingredients set cost_per_unit_note = (cost_per_unit_note || standard_unit_note)")
  end
end
