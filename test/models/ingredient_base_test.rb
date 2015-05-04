require 'test_helper'

class IngredientBaseTest < ActiveSupport::TestCase
  def setup
    @full_ing = ingredient_bases(:salt)
  end
  
  test "starts as valid" do
    i = @full_ing
    assert i.valid?
  end

  test "name too short" do
    i = @full_ing
    i.name = "t"
    assert_not i.valid?
  end
  
  test "name unique" do
    dup = @full_ing.dup
    assert_not dup.valid?
  end
  
  test "can't delete if linked ingredients" do
    salt = ingredient_bases(:salt)
    assert_no_difference 'IngredientBase.count' do
      salt.destroy
    end
  end
  
end
