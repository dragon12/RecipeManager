require 'test_helper'

class UserRatingsControllerTest < ActionController::TestCase
  def setup
    @recipe = recipes(:recipe2)
    @rating = user_ratings(:user1_recipe2)
  end
  
  test "should redirect update to recipes when no recipe" do
    patch :update, id: @rating, 
                    user_rating: { rating: 5.5 }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to recipes_url
  end
  
  test "should redirect update when not logged in" do
    patch :update, id: @rating, 
                    user_rating: { rating: 5.5, recipe_id: @recipe.id }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to @rating.recipe
  end
end
