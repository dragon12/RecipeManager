require 'test_helper'

class RecipeAddRecipeTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
  end
  
  test "go to add recipe page" do
    log_in_as(@admin)
    get new_recipe_path
    
    assert_template 'recipes/new'
  end
  
end