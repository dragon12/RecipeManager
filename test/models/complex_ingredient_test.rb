#coding: utf-8
require 'test_helper'

class ComplexIngredientTest < ActiveSupport::TestCase
  def setup
    
  end
  
  test "can't create blank" do
    ci = ComplexIngredient.new
    
    assert_not ci.valid?
  end
  
  test "can create with link and recipe" do
    ci = ComplexIngredient.new
    il = ci.build_ingredient_link
    ci.recipe = recipes(:recipe2)
    
    assert ci.valid?
  end
  
  test "can query complex as component" do
    ci = complex_ingredients(:complex_component1)
    r = recipes(:recipe3) #the related recipe
    cl = ci.ingredient_link
    assert_equal "Recipe: #{r.name}", cl.ingredient_base.name
    #the recipe has 2 portions
    assert_equal (3*r.total_cost / 2), cl.cost_for_quantity(3)
    assert_equal (3.5*r.total_kcal / 2), cl.kcal_for_quantity(3.5)
    assert_equal measurement_types(:quantity), cl.measurement_type
    assert_equal "By Quantity", cl.measurement_type_str
    assert_equal "£%.2f" % r.total_cost, cl.cost_str
    assert_equal "%d" % r.total_kcal, cl.kcal_str
  end

  #the recipe has no defined portions, should default to 1
  test "can query complex with no set portion count" do
    ci = complex_ingredients(:complex_component2)
    cl = ci.ingredient_link
    r = recipes(:recipe4)
    assert_equal (3*r.total_cost), cl.cost_for_quantity(3)
    assert_equal (3.5*r.total_kcal), cl.kcal_for_quantity(3.5)
  end
end
