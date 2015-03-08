require 'test_helper'

class RecipeEditUserRatingTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:archer)
  end
  
  test "fail creation of blank rating" do
    log_in_as(@user)
    #archer has not rated recipe 1
    r = recipes(:recipe1)
    get recipe_path(r)
    
    assert_template 'recipes/show'
    
    #create a new user rating
    assert_no_difference 'UserRating.count' do
      post recipe_user_ratings_path(r, user_rating: {rating: nil, user_id: @user.id})
    end
    assert_not flash.empty?
    assert_redirected_to r
  end
  
  test "fail creation of invalid rating" do
    log_in_as(@user)
    #archer has not rated recipe 1
    r = recipes(:recipe1)
    get recipe_path(r)
    
    assert_template 'recipes/show'
   
    #create a new user rating
    assert_no_difference 'UserRating.count' do
      post recipe_user_ratings_path(r, user_rating: {rating: 12, user_id: @user.id})
    end
    assert_not flash.empty?
    assert_redirected_to r
  end
  
  test "successful creation of rating" do
    log_in_as(@user)
    #archer has not rated recipe 1
    r = recipes(:recipe1)
    get recipe_path(r)
    
    assert_template 'recipes/show'
    
    #create a new user rating
    assert_difference 'UserRating.count', 1 do
      post recipe_user_ratings_path(r, user_rating: {rating: 5, user_id: @user.id})
    end
    assert flash.empty?
    assert_redirected_to r
    r.reload
    assert_equal "5", r.rating_for_user(@user)
  end
  
  test "successful creation of second rating" do
    u = users(:michael)
    log_in_as(u)
    #michael has not rated recipe 2, archer has
    r = recipes(:recipe2)
    get recipe_path(r)
    
    assert_template 'recipes/show'
    
    #create a new user rating
    assert_difference 'UserRating.count', 1 do
      post recipe_user_ratings_path(r, user_rating: {rating: 5, user_id: u.id})
    end
    assert flash.empty?
    assert_redirected_to r
    r.reload
    assert_equal "5", r.rating_for_user(u)
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
      patch recipe_user_rating_path(r, @ur), 
              user_rating: {rating: 7, user_id: @user.id}
    end
    
    assert flash.empty?
    assert_redirected_to r
    r.reload
    assert_equal "7", r.rating_for_user(@user)
  end
  
  
  test "successful deletion of rating" do
    log_in_as(@user)
    #archer has previously rated recipe 2 a 10
    r = recipes(:recipe2)
    get recipe_path(r)
    
    assert_template 'recipes/show'
    assert_equal "10", r.rating_for_user(@user)
    
    ur = r.user_rating(@user)
    #delete the existing rating
    assert_difference 'UserRating.count', -1 do
      delete recipe_user_rating_path(r, ur)
    end
    
    assert_not flash.empty?
    assert_redirected_to r
    r.reload
    assert r.user_rating(@user).blank?
  end
  
  
  test "fail update of rating" do
    log_in_as(@user)
    #archer has previously rated recipe 2 a 10
    r = recipes(:recipe2)
    get recipe_path(r)
    
    assert_template 'recipes/show'
    assert_equal "10", r.rating_for_user(@user)
    
    #update the existing rating
    @ur = UserRating.find_by!(user_id: @user.id, recipe_id: r.id)
    assert_no_difference 'UserRating.count' do
      patch recipe_user_rating_path(r, @ur), 
              user_rating: {rating: -1, user_id: @user.id}
    end
    
    assert_not flash.empty?
    assert_redirected_to r
    r.reload
    assert_equal "10", r.rating_for_user(@user)
  end
end

