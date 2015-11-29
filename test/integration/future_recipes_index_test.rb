require 'test_helper'

class FutureRecipesIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  #should strip trailing whitespace
  test "search by future recipe name whitespace" do
    capy_login_as_admin
    visit future_recipes_path
    fill_in('search_by_future_recipe_name', :with => 'ecipe One ')
    
    #capybara can't find by 'name' attribute properly
    #click_button('submit_search_by_recipe_name')
    find(:xpath, "//input[contains(@name, 'submit_search_by_future_recipe_name')]").click()
    
    assert_equal current_path, future_recipes_path
    
    FutureRecipe.all.each do |recipe|
      if recipe.name =~ /ecipe One/i
        assert_select 'a[href=?]', future_recipe_path(recipe), text: recipe.name, count: 1
      else
        assert_select 'a[href=?]', future_recipe_path(recipe), text: recipe.name, count: 0
      end
    end
  end
end
