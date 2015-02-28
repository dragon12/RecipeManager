require 'test_helper'

class IngredientsControllerTest < ActionController::TestCase
  def setup
    @admin_user = users(:michael)
    @other_user = users(:archer)
    
    @ing = ingredients(:salt)
  end
  
  
  test "should redirect update when not logged in" do
    patch :update, id: @ing, 
                    ingredient: { name: "New Name" }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to ingredients_url
  end
  
  test "should redirect update when not admin" do
    log_in_as(@other_user)
    patch :update, id: @ing, 
                    ingredient: { name: "New Name" }
    assert_not flash.empty?
    assert_redirected_to ingredients_url
  end
  
  test "should allow update when admin" do
    log_in_as(@admin_user)
    patch :update, id: @ing, 
                    ingredient: { name: "New Name" }
    #assert_match 'boohooo', @response.body
    assert flash.empty?
    assert_redirected_to ingredients_path
    assert_equal "New Name", @ing.reload.name
  end
end
