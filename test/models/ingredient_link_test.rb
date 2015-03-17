require 'test_helper'

class IngredientLinkTest < ActiveSupport::TestCase
  def setup
    @ingredient_link = ingredient_links(:salt)
    @complex_link = ingredient_links(:complex_link_1)
  end
  
  test "should be valid" do
    assert @ingredient_link.valid?, "#{@ingredient_link.errors.full_messages}"
  end
  
  
  test "complex should be valid" do
    assert @complex_link.valid?, "#{@complex_link.errors.full_messages}"
  end
  
  
  test "name is right" do
    assert_equal "Salt", @ingredient_link.name
  end
  
  
  test "cost for quantity" do
    i = @ingredient_link
    
    #salt is 1 per 100
    
    assert_equal 2.0, i.cost_for_quantity(200)
  end
  
  test "kcal for quantity" do
    i = @ingredient_link
    
    #salt is 50 per 100
    assert_equal 125, i.kcal_for_quantity(250)
  end
  
  test "order_by_returns_right_number" do
    assert_equal 6, IngredientLink.order_by_name.count
  end
  
end
