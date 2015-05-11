require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  def setup
    @admin_user = users(:michael)
    @other_user = users(:archer)
    
    @cat_food = categories(:food)
  end
  
  
  test "should redirect update when not logged in" do
    patch :update, id: @cat_food, 
                    category: { name: "New Name" }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to categories_url
  end
  
  
  test "should redirect update when not admin" do
    log_in_as(@other_user)
    patch :update, id: @cat_food, 
                    category: { name: "New Name" }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to categories_url
  end
  
  
  test "should allow update when admin" do
    log_in_as(@admin_user)
    patch :update, id: @cat_food, 
                    category: { name: "New Name" }
    #assert_match 'boohooo', @response.body
    assert flash.empty?
    assert_redirected_to categories_path
    @cat_food.reload
    assert_equal "New Name", @cat_food.name
  end
  
  
  test "delete category fails when has recipe" do
    log_in_as(@admin_user)
    
    num_cats_before = Category.count
    
    cat_wine = categories(:wine)
    post :destroy, id: cat_wine.id
    
    assert_redirected_to categories_path

    assert_equal num_cats_before, Category.count
  end
  
  
  test "delete category succeeds when has no recipe" do
    log_in_as(@admin_user)
    
    num_cats_before = Category.count
    
    cat_unused = categories(:unused_category)
    post :destroy, id: cat_unused.id
    
    assert_redirected_to categories_path

    assert_equal num_cats_before - 1, Category.count
  end
  
  
  
end
