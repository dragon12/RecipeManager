require 'test_helper'

class UserRatingTest < ActiveSupport::TestCase
  def setup
    @r = user_ratings(:user1_recipe2)
  end
  
  test "should be valid" do
    assert @r.valid?, "#{@r.errors.full_messages}"
  end
  
  test "should have recipe" do
    @r.recipe = nil
    assert_not @r.valid?, "#{@r.errors.full_messages}"
  end
  
  test "should have user" do
    @r.user = nil
    assert_not @r.valid?, "#{@r.errors.full_messages}"
  end
  
  test "should have rating" do
    @r.rating = nil
    assert_not @r.valid?, "#{@r.errors.full_messages}"
  end
  
  test "shouldn't allow duplicate user/recipe combo" do
    @r2 = @r.dup
    assert_not @r2.valid?, "#{@r2.errors.full_messages}"
  end
  
  test "should allow same user to rate multiple recipes" do
    r2 = @r.dup
    r2.recipe = recipes(:recipe4)
    assert r2.valid?, "#{r2.errors.full_messages}"
  end
  
  test "should allow same recipe to have ratings from multiple users" do
    r2 = @r.dup
    r2.user = users(:mallory)
    assert r2.valid?, "#{r2.errors.full_messages}"
  end
  
  test "should not allow >10" do
    @r.rating = 11
    assert_not @r.valid?, "#{@r.errors.full_messages}"
  end
end
