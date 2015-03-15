require 'test_helper'

class RecipesIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as nonadmin" do
    log_in_as(@non_admin)
    get recipes_path
    assert_template 'recipes/index'
    assert_not_equal 0, Recipe.all.count
    Recipe.all.each do |recipe|
      assert_select 'a[href=?]', recipe_path(recipe), text: recipe.name
    end
    assert_select 'a', text: 'delete', count: 0
    assert_select 'a', text: 'edit', count: 0
    
  end
  
  test "index as admin including edit and delete links" do
    log_in_as(@admin)
    get recipes_path
    assert_template 'recipes/index'
    #assert_match 'boohooo', @response.body
    Recipe.all.each do |recipe|
      assert_select 'a[href=?]', recipe_path(recipe), text: recipe.name, count: 1
      assert_select 'a[href=?]', edit_recipe_path(recipe), text: 'Edit', count: 1
    end
  end
  
  test "search by ingredient id" do
    log_in_as(@non_admin)
    salt_link = ingredient_links(:salt)
    get recipes_path, :search_by_ingredient_link_id => salt_link.id
    Recipe.all.each do |recipe|
      if recipe.ingredient_links.exists?(salt_link.id)
        assert_select 'a[href=?]', recipe_path(recipe), text: recipe.name, count: 1
      else
        assert_select 'a[href=?]', recipe_path(recipe), text: recipe.name, count: 0
      end
    end
  end

  test "search by ingredient name" do
    log_in_as(@non_admin)
    get recipes_path, :search_by_ingredient_name => "salt"
    Recipe.all.each do |recipe|
      if recipe.ingredient_links.any? {|il| il.name =~ /salt/i }
        assert_select 'a[href=?]', recipe_path(recipe), text: recipe.name, count: 1
      else
        assert_select 'a[href=?]', recipe_path(recipe), text: recipe.name, count: 0
      end
    end
  end
end