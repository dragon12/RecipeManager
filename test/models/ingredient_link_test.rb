require 'test_helper'

class IngredientLinkTest < ActiveSupport::TestCase
  def setup
    @ingredient_link = ingredient_links(:salt)
  end
  
  test "should be valid" do
    assert @ingredient_link.valid?, "#{@ingredient_link.errors.full_messages}"
  end
end
