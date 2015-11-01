require 'test_helper'

class FutureRecipeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @fr1 = future_recipes(:one)
    @fr2 = future_recipes(:two)
  end

  
  test "can't add duplicate link" do
    fr3 = @fr1.dup
    assert_not fr3.valid?
    fr3.link = "http://www.yeah.ok"
    assert fr3.valid?
  end

  test "can't add link that is in real recipes" do
    existing_link = links(:one)
    fr3 = @fr1.dup
    fr3.link = "http://www.yeah.ok"
    assert fr3.valid?
    fr3.link = existing_link.url
    assert_not fr3.valid?
  end
end
