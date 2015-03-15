require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
    
  def setup
    @full_ing = ingredients(:salt)
  end
  
  test "should be valid" do
    assert @full_ing.valid?, "#{@full_ing.errors.full_messages}"
  end
  
  test "no measurement type" do
    @full_ing.measurement_type = nil
    assert_not @full_ing.valid?
  end
  
  test "no ingredient link" do
    @full_ing.ingredient_link = nil
    assert_not @full_ing.valid?
  end
    
  test "name too short" do
    i = @full_ing
    i.name = "t"
    assert_not i.valid?
  end
  
  test "cost for quantity" do
    i = @full_ing
    i.cost_basis = 100
    i.cost = 2.5
    
    assert_equal 5.0, i.cost_for_quantity(200)
  end
  
  test "kcal for quantity" do
    i = @full_ing
    i.kcal_basis = 10
    i.kcal = 50
    assert_equal 500, i.kcal_for_quantity(100)
  end
end
  
