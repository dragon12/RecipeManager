require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  
  def setup
    @link = Link.new(recipe_id: 1, 
                     description: "desc", 
                     url: "http://www.example.com")
    
  end
  
  test "should be valid" do
    assert @link.valid?
  end
  
  test "empty description not valid" do
    @link.description = "  "
    assert_not @link.valid?
  end
  
  test "empty url not valid" do
    @link.url = ""
    assert_not @link.valid?
  end
    
  test "bad url not valid" do
    @link.url = "1234"
    assert_not @link.valid?
  end

  test "url without http not valid" do
    @link.url = "www.example.com"
    assert_not @link.valid?
  end

end
