# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

salt = Ingredient.create(name: 'Salt')
pepper = Ingredient.create(name: 'Pepper')
chickpeas = Ingredient.create(name: 'Chickpeas')

sampleRecipe = Recipe.new(name: 'Sample Recipe', description: 'This is a sample')

sampleRecipe.ingredient_quantities.build(
      quantity: '5 tsp', 
      preparation: 'mixed',
      ingredient: salt,
      recipe: sampleRecipe)

sampleRecipe.ingredient_quantities.build(
  quantity: '500g', preparation: 'boiled', ingredient: chickpeas, recipe: sampleRecipe)

#sampleRecipe.ingredient_quantities << iq1
#sampleRecipe.ingredient_quantities << iq2

sampleRecipe.instructions.build(step_number: 1, details: 'do the thing')

sampleRecipe.save