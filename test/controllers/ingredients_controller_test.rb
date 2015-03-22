require 'test_helper'

class IngredientsControllerTest < ActionController::TestCase
  def setup
    @admin_user = users(:michael)
    @other_user = users(:archer)
    
    @ing = ingredients(:salt)
  end
  
  
  test "should redirect update when not logged in" do
    patch :update, id: @ing, 
                    ingredient: { name: "New Name" }
    assert_not flash.empty?, "#{flash.inspect}"
    assert_redirected_to ingredients_url
  end
  
  test "should redirect update when not admin" do
    log_in_as(@other_user)
    patch :update, id: @ing, 
                    ingredient: { name: "New Name" }
    assert_not flash.empty?
    assert_redirected_to ingredients_url
  end
  
  test "should allow update when admin" do
    log_in_as(@admin_user)
    patch :update, id: @ing, 
                    ingredient: { name: "New Name" }
    #assert_match 'boohooo', @response.body
    assert flash.empty?
    assert_redirected_to ingredients_path
    assert_equal "New Name", @ing.reload.name
  end
  
  
  test "create ingredient creates ingredient link" do
    log_in_as(@admin_user)
    
    num_ingredients_before = Ingredient.count
    num_ingredient_links_before = IngredientLink.count
    
    post :create, ingredient: {name: 'new ingredient', 
                                measurement_type_id: measurement_types(:weight).id,
                                cost_basis: 100, cost: 1,
                                kcal_basis: 100, kcal: 2
                                 }
    
    #assert_equal 'test', @response.body
    assert flash.empty?
    assert_redirected_to ingredients_path

    assert_equal num_ingredients_before + 1, Ingredient.count
    assert_equal num_ingredient_links_before + 1, IngredientLink.count
  end
  
  test "delete ingredient destroys link when no recipes" do
    log_in_as(@admin_user)
    
    num_ingredients_before = Ingredient.count
    num_ingredient_links_before = IngredientLink.count
    
    ing = ingredients(:pepper)
    post :destroy, id: ing.id
    
    assert_redirected_to ingredients_path

    assert_equal num_ingredients_before - 1, Ingredient.count
    assert_equal num_ingredient_links_before - 1, IngredientLink.count
  end
  
  test "delete ingredient fails when has recipe" do
    log_in_as(@admin_user)
    
    num_ingredients_before = Ingredient.count
    num_ingredient_links_before = IngredientLink.count
    
    ing = ingredients(:carrot)
    post :destroy, id: ing.id
    
    assert_redirected_to ingredients_path

    assert_equal num_ingredients_before, Ingredient.count
    assert_equal num_ingredient_links_before, IngredientLink.count
  end
  
  
end
