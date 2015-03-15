require 'test_helper'

class RecipeEditTest < ActionDispatch::IntegrationTest
  def setup
    @r = recipes(:recipe2)
    @admin = users(:michael)
  end
  
  test "add ingredient to existing recipe" do
    capy_login_as_admin
    
    num_ingredients_before = @r.ingredient_quantities.count
    
    visit(edit_recipe_path(@r))
    click_link('Add Ingredient')
    
    within all('#ingredient_group_table').last do
      within all('.table-row').last do
        find('.table-col-1-4').all('input').last.set('6')
        find('.table-col-2-4').find('select').select('Rot (By Weight)')
        find('.table-col-3-4').find('input').set('good prep')
      end
    end
    click_button('Update Recipe', match: :first)
    
    #this forces waiting for the page to load so that the model will be updated
    assert_equal current_path, recipe_path(@r)

    #save_and_open_page
    
    @r.reload
    assert_equal num_ingredients_before + 1, @r.ingredient_quantities.count
    
  end
end
