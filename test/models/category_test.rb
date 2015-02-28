require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def setup
    @cat = categories(:food)
    @unused_cat = categories(:unused_category)
  end
  
  test "should be valid" do
    assert @cat.valid?, "#{@cat.errors.full_messages}"
  end
  
  test "can delete unused category" do
    assert_equal 0, @unused_cat.recipes.count
    assert_difference 'Category.count', -1 do
      @unused_cat.destroy
    end
  end
  
  test "cannot delete used category" do
    assert_not_equal 0, @cat.recipes.count
    assert_no_difference 'Category.count' do
      @cat.destroy
    end
  end
  
  
end
