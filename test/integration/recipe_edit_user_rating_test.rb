require 'test_helper'

class RecipeEditUserRatingTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:archer)
  end
  
  test "successful creation of rating" do
    log_in_as(@user)
    #archer has not rated recipe 1
    r = recipes(:recipe1)
    get recipe_path(r)
    
    assert_template 'recipes/show'
    
    #create a new user rating
    assert_difference 'UserRating.count', 1 do
      post user_ratings_path, user_rating: {rating: 5, user_id: @user.id, recipe_id: r.id}
    end
    assert flash.empty?
    assert_redirected_to r
    r.reload
    assert_equal "5", r.rating_for_user(@user)
  end
  
  
  test "successful update of rating" do
    log_in_as(@user)
    #archer has previously rated recipe 2 a 10
    r = recipes(:recipe2)
    get recipe_path(r)
    
    assert_template 'recipes/show'
    assert_equal "10", r.rating_for_user(@user)
    
    #update the existing rating
    @ur = UserRating.find_by!(user_id: @user.id, recipe_id: r.id)
    assert_no_difference 'UserRating.count' do
      patch user_rating_path(@ur), 
              user_rating: {rating: 7, user_id: @user.id, recipe_id: r.id}
    end
    
    assert flash.empty?
    assert_redirected_to r
    r.reload
    assert_equal "7", r.rating_for_user(@user)
  end
end

