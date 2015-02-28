require 'test_helper'

class UserRatingTest < ActiveSupport::TestCase
  def setup
    @r = user_ratings(:user1_recipe1)
  end
  
  test "should be valid" do
    assert @r.valid?, "#{@r.errors.full_messages}"
  end
  
  test "should have recipe" do
    @r.recipe = nil
    assert_not @r.valid?
  end
  
  test "should have user" do
    @r.user = nil
    assert_not @r.valid?
  end
end
