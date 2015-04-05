require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  def setup
    @admin_user = users(:michael)
    @other_user = users(:archer)
    
    @rec1 = recipes(:recipe1)
  end
  
  
  test "should redirect update when not logged in" do
    patch :update, id: @rec1, 
                    recipe: { name: "New Name" }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to recipes_url
  end
  
  test "should redirect update when not admin" do
    log_in_as(@other_user)
    patch :update, id: @rec1, 
                    recipe: { name: "New Name" }
    assert_not flash.empty?
    assert_redirected_to recipes_url
  end
  
  test "should allow update when admin" do
    log_in_as(@admin_user)
    patch :update, id: @rec1, 
                    recipe: { name: "New Name" }
    #assert_match 'boohooo', @response.body
    assert flash.empty?
    assert_redirected_to @rec1
    assert_equal "New Name", @rec1.reload.name
  end
  
  test "should sort by name when told" do
    get :index, :sort_by => "name"
    #assert_match 'boohooo', @response.body
    
    assert_equal "AAAAfirst", assigns(:recipes).first.name
  end
end
