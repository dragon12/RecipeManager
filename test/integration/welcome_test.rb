require 'test_helper'

class WelcomeTest < ActionDispatch::IntegrationTest
  def setup
    
  end
  
  test "welcome index" do
    visit root_path
    assert page.has_content?('Recently Updated Recipes')
  end
end