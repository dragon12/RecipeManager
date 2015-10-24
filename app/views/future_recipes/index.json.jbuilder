json.array!(@future_recipes) do |future_recipe|
  json.extract! future_recipe, :id, :name, :link, :description
  json.url future_recipe_url(future_recipe, format: :json)
end
