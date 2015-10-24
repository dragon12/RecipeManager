require 'test_helper'

class FutureRecipesControllerTest < ActionController::TestCase
  setup do
    @future_recipe = future_recipes(:one)
    @admin_user = users(:michael)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:future_recipes)
  end

  test "should get new" do
    log_in_as(@admin_user)
    get :new
    assert_response :success
  end

  test "should show future_recipe" do
    get :show, id: @future_recipe
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@admin_user)
    get :edit, id: @future_recipe
    assert_response :success
  end

  test "should update future_recipe" do
    log_in_as(@admin_user)
    patch :update, id: @future_recipe, future_recipe: { description: @future_recipe.description, link: @future_recipe.link, name: @future_recipe.name }
    assert_redirected_to future_recipe_path(assigns(:future_recipe))
  end

  test "should destroy future_recipe" do
    log_in_as(@admin_user)
    assert_difference('FutureRecipe.count', -1) do
      delete :destroy, id: @future_recipe
    end

    assert_redirected_to future_recipes_path
  end
end
