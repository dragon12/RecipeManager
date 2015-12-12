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
  
  
  test "filter by category" do
    cat = categories(:test_two_future_recipe_category)
    
    filtered = FutureRecipe.search_by_category_id(cat.id)
    
    assert_equal 2, filtered.count
  end
  
  test "filter by name" do
    #first three recipes are named 'FutRecipeTestFilter %'
    filtered = FutureRecipe.search_by_name("FutRecipeTestFilter")
    
    assert_equal 3, filtered.count
  end
  
  test "filter by website" do
    filtered = FutureRecipe.search_by_website("tes")
    
    assert_equal 1, filtered.count
  end
  
  test "check positive rank" do
    assert_equal 5, future_recipes(:six_positive_rank).rank
  end
  
  test "check negative rank" do
    assert_equal 5 * -1, future_recipes(:seven_negative_rank).rank
  end
end
