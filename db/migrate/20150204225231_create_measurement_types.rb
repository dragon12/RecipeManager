class CreateMeasurementTypes < ActiveRecord::Migration
  def change
    create_table :measurement_types do |t|
      t.string :measurement_type
      
      t.timestamps
    end
  end
end
