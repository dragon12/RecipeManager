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
    @ing.reload
    assert_equal "New Name", @ing.name
  end
  
  
  test "create ingredient creates ingredient link and ingredient base" do
    log_in_as(@admin_user)
    
    num_ingredients_before = Ingredient.count
    num_ingredient_links_before = IngredientLink.count
    num_ingredient_bases_before = IngredientBase.count
    
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
    assert_equal num_ingredient_bases_before + 1, IngredientBase.count
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
  
  test "adding new measurement for existing ingredient reuses base" do
    log_in_as(@admin_user)
    
    num_ingredients_before = Ingredient.count
    num_ingredient_bases_before = IngredientBase.count
    
    post :create, ingredient: {name: 'Salt', 
                                measurement_type_id: measurement_types(:weight).id,
                                cost_basis: 100, cost: 1,
                                kcal_basis: 100, kcal: 2
                                 }
    
    #assert_equal 'test', @response.body
    assert flash.empty?
    assert_redirected_to ingredients_path


    ib = IngredientBase.where(name: 'Salt')
    ils = IngredientLink.where(ingredient_base: ib)
    assert_equal 2, ils.count
    assert_equal 1, ib.count

    assert_equal num_ingredients_before + 1, Ingredient.count
    assert_equal num_ingredient_bases_before, IngredientBase.count
  end
  
    
  test "delete ingredient deletes ingredient base when none left" do
    log_in_as(@admin_user)
    
    num_ingredients_before = Ingredient.count
    num_ingredient_bases_before = IngredientBase.count
    
    ing = ingredients(:pepper)
    post :destroy, id: ing.id
    
    assert_redirected_to ingredients_path

    assert_equal num_ingredients_before - 1, Ingredient.count
    assert_equal num_ingredient_bases_before - 1, IngredientBase.count
  end
  
    
    
  test "delete ingredient doesn't delete ingredient base when others left" do
    log_in_as(@admin_user)
    
    num_ingredients_before = Ingredient.count
    num_ingredient_bases_before = IngredientBase.count
    
    #both test_adding and test_adding2 point to the same base
    ing = ingredients(:test_adding)
    post :destroy, id: ing.id
    
    assert_redirected_to ingredients_path

    assert_equal num_ingredients_before - 1, Ingredient.count
    assert_equal num_ingredient_bases_before, IngredientBase.count
    
    ing2 = ingredients(:test_adding2)
    post :destroy, id: ing2.id

    assert_redirected_to ingredients_path

    assert_equal num_ingredients_before - 2, Ingredient.count
    assert_equal num_ingredient_bases_before - 1, IngredientBase.count
        
  end
  
end
