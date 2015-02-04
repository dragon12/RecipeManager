class AddMeasurementNameToMeasurementTypes < ActiveRecord::Migration
  def change
    add_column :measurement_types, :measurement_name, :string
  end
end
