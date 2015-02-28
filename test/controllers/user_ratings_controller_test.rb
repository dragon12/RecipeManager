require 'test_helper'

class UserRatingsControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
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
  
  test "should redirect create when not logged in" do
    put :create, user_rating: { rating: 5.5, recipe_id: @recipe.id }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to @rating.recipe
  end
  
  test "should create rating when logged in" do
    log_in_as(@user)
    assert_difference 'UserRating.count', 1 do
      put :create, user_rating: { rating: 5.5, recipe_id: @recipe.id, user_id: @user.id }
    end
    
    assert flash.empty?, "#{flash.inspect}"
    assert_redirected_to @recipe
  end
  
  test "should update rating when logged in" do
    log_in_as(@user)
    patch :update, id: @rating, 
                    user_rating: { rating: 5.5, recipe_id: @recipe.id }
                    
    assert flash.empty?, "#{flash.inspect}"
    #assert_match 'boohooo', @response.body

    assert_redirected_to @recipe
    assert_equal 5.5, @rating.reload.rating
  end
end
