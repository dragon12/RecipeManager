require 'test_helper'

class IngredientQuantityGroupTest < ActiveSupport::TestCase
  def setup
    @iqg_one_iq = ingredient_quantity_groups(:group2_recipe1)
    @iqg_two_iq = ingredient_quantity_groups(:group1_recipe1)
  end
  
  test "iqg one is valid" do
    assert @iqg_one_iq.valid?, "#{@iqg_one_iq.errors.full_messages}"
  end
  
  test "iqg two is valid" do
    assert @iqg_two_iq.valid?, "#{@iqg_two_iq.errors.full_messages}"
  end
  
  
  test "cost calculates ok single ingredient" do
    #5 carrot @ 2.0 per 100
    assert_equal "0.09", @iqg_two_iq.cost.to_s
  end
  
  test "cost calculates ok multiple ingredients" do
    #3 salt @ 1.0 per 100
    #3 carrot @ 2.0 per 100
    assert_equal "0.1", @iqg_one_iq.cost.to_s
  end
end

