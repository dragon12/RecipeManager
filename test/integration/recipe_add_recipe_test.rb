require 'test_helper'

class RecipeAddRecipeTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
  end
  
  test "add recipe" do
    capy_login_as_admin
    visit(new_recipe_path)
    assert_equal current_path, new_recipe_path
  end
  
end