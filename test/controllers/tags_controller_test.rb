require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  def setup
    @admin_user = users(:michael)
    @other_user = users(:archer)
    
    @tag_hard = tags(:hard)
  end
  
  
  test "should redirect update when not logged in" do
    patch :update, id: @tag_hard, 
                    tag: { name: "New Name" }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to tags_url
  end
  
  
  test "should redirect update when not admin" do
    log_in_as(@other_user)
    patch :update, id: @tag_hard, 
                    tag: { name: "New Name" }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to tags_url
  end
  
  
  test "should allow update when admin" do
    log_in_as(@admin_user)
    patch :update, id: @tag_hard, 
                    tag: { name: "New Name" }
    #assert_match 'boohooo', @response.body
    assert flash.empty?
    assert_redirected_to tags_path
    @tag_hard.reload
    assert_equal "New Name", @tag_hard.name
  end
  
  
  test "delete tag fails when has recipe" do
    log_in_as(@admin_user)
    
    num_tags_before = Tag.count
    
    tag_wine = tags(:easy)
    post :destroy, id: tag_wine.id
    
    assert_redirected_to tags_path

    assert_equal num_tags_before, Tag.count
  end
  
  
  test "delete tag succeeds when has no recipe" do
    log_in_as(@admin_user)
    
    num_tags_before = Tag.count
    
    tag_unused = tags(:unused)
    post :destroy, id: tag_unused.id
    
    assert_redirected_to tags_path

    assert_equal num_tags_before - 1, Tag.count
  end
  
  
  
end
