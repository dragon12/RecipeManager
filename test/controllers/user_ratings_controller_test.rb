require 'test_helper'

class UserRatingsControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
    @recipe = recipes(:recipe2)
    @rating = user_ratings(:user1_recipe2)
  end
  
  test "should redirect update when not logged in" do
    patch :update, id: @rating, recipe_id: @recipe.id,
                    user_rating: { rating: 5.5 }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to @rating.recipe
  end
  
  test "should redirect create when not logged in" do
    put :create, recipe_id: @recipe.id, user_rating: { rating: 5.5 }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to @rating.recipe
  end
  
  test "should redirect destroy when not logged in" do
    delete :destroy, recipe_id: @recipe.id, id: @rating.id
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to @rating.recipe
  end
  
  test "should create rating when logged in" do
    log_in_as(@user)
    assert_difference 'UserRating.count', 1 do
      post :create, recipe_id: @recipe.id, user_rating: { rating: 5.5, user_id: @user.id }
    end
    
    assert flash.empty?, "#{flash.inspect}"
    assert_redirected_to @recipe
  end
  
  test "should update rating when logged in" do
    log_in_as(@user)
    
    assert_no_difference 'UserRating.count' do
      patch :update, id: @rating, recipe_id: @recipe.id, 
                    user_rating: { rating: 5.5 }
    end
                    
    assert flash.empty?, "#{flash.inspect}"
    #assert_match 'boohooo', @response.body

    assert_redirected_to @recipe
    assert_equal 5.5, @rating.reload.rating
  end
end
