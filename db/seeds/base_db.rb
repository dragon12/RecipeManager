# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

vol = MeasurementType.create(measurement_type: 'By Volume (ml)', measurement_name: 'ml')
vol.save

weight = MeasurementType.create(measurement_type: 'By Weight (g)', measurement_name: 'g')
weight.save

items = MeasurementType.create(measurement_type: 'By Quantity', measurement_name: '')
items.save

vol2 = MeasurementType.create(measurement_type: 'By Volume (tsp)', measurement_name: 'tsp')
vol2.save