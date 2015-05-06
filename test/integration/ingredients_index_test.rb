require 'test_helper'

class IngredientsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
  end
  
  test "ingredients index" do
    capy_login_as_admin
    
    visit ingredients_path
    #save_and_open_page
    assert page.has_content?('Ingredients')
    assert_equal current_path, ingredients_path
  end
  
  test "add new ingredient" do
    capy_login_as_admin
    
    visit ingredients_path
    
    num_ingredients_before = Ingredient.count
    num_ingredient_links_before = IngredientLink.count
    
    fill_in('ingredient[name]', :with => 'test')
    select('Weight', :from => 'ingredient[measurement_type_id]')
    fill_in('Cost basis', :with => '100')
    fill_in('Cost', :with => '2')
    fill_in('ingredient_cost_note', :with => 'test note')
    fill_in('Kcal basis', :with => '100')
    fill_in('Kcal', :with => '2')
    fill_in('ingredient_kcal_note', :with => 'test note')
    click_button('Create Ingredient')
    
    assert_equal current_path, ingredients_path
    #save_and_open_page
    
    assert_equal num_ingredients_before + 1, Ingredient.count
    assert_equal num_ingredient_links_before + 1, IngredientLink.count
  end
  
  test "ingredient index has edit and delete for admin" do
    log_in_as(@admin)
    get ingredients_path
    assert_template 'ingredients/index'
    #assert_match 'boohooo', @response.body
    #puts "TEST: starting test"
    IngredientLink.all.each do |ing|
      #puts "TEST: looking at ing #{ing.inspect}"
      #assert_select "a", :href => /search_by_ingredient_link_id=
      assert_match(/href="\/recipes\?search_by_ingredient_base_id=#{ing.ingredient_base.id}/, response.body)
      
      #assert_select 'a[href=/recipes\?search_by_ingredient_link_id=?]', ing.id, text: ing.recipes_count, count: 1
      if ing.recipe_component_type == 'Ingredient'
        assert_select 'a[href=?]', ingredient_path(ing.ingredient), text: 'Edit', count: 1
        assert_select 'a[href=?]', ingredient_path(ing.ingredient), text: 'Delete', method: :delete, count: 1
      else
        assert_select 'a[href=?]', recipe_path(ing.complex_ingredient.recipe), text: ing.name, count: 1
      end
    end
  end
  
end
