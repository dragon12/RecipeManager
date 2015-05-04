require 'test_helper'

class IngredientLinkTest < ActiveSupport::TestCase
  def setup
    @ingredient_link = ingredient_links(:salt)
    @complex_link = ingredient_links(:complex_link_1)
  end
  
  test "should be valid" do
    assert @ingredient_link.valid?, "#{@ingredient_link.errors.full_messages}"
    assert @ingredient_link.editable?
    assert_not @ingredient_link.linkable?
  end
  
  
  test "no ingredient base" do
    @ingredient_link.ingredient_base = nil
    assert_not @ingredient_link.valid?
  end
  
  test "complex should be valid" do
    assert @complex_link.valid?, "#{@complex_link.errors.full_messages}"
    assert_not @complex_link.editable?
    assert @complex_link.linkable?
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
  
  
end
