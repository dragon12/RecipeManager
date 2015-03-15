require 'test_helper'

class IngredientsIndexTest < ActionDispatch::IntegrationTest
  def setup
    
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
end
