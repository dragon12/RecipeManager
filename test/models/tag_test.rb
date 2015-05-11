require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @hard = tags(:hard)
    @unused_tag = tags(:unused)
  end
  
  test "should be valid" do
    assert @hard.valid?, "#{@hard.errors.full_messages}"
  end
  
  test "can delete unused tag" do
    assert_equal 0, @unused_tag.recipes.count
    assert_difference 'Tag.count', -1 do
      @unused_tag.destroy
    end
  end
  
  test "cannot delete used tag" do
    assert_not_equal 0, @hard.recipes.count
    assert_no_difference 'Tag.count' do
      @hard.destroy
    end
  end
  
  
end
