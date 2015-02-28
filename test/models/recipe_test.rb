#coding: utf-8
require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @recipe_one_group = recipes(:recipe2)
    @recipe_two_groups = recipes(:recipe1)
  end
  
  test "recipe cost single group" do
    #we test the groups elsewhere
    cost = ingredient_quantity_groups(:group1_recipe2).cost;
    
    cost_str = "£%.2f" % cost
    assert_equal cost_str, @recipe_one_group.total_cost
  end
  
  test "recipe cost multiple groups" do
    #we test the groups elsewhere
    cost = ingredient_quantity_groups(:group1_recipe1).cost + 
            ingredient_quantity_groups(:group2_recipe1).cost 
    
    cost_str = "£%.2f" % cost
    assert_equal cost_str, @recipe_two_groups.total_cost
  end
  
  test "filter by category" do
    cat = categories(:food)
    
    filtered = Recipe.search_by_category_id(cat.id)
    
    assert_equal 2, filtered.count
  end
  
  test "filter by name" do
    #first three recipes are named 'Recipe %'
    filtered = Recipe.search_by_name("recipe")
    
    assert_equal 3, filtered.count
  end
  
  test "filter by ingredient id" do
    #carrot appears twice in recipe1 and once in recipe 3
    carrot = ingredients(:carrot)
    filtered = Recipe.search_by_ingredient_id(carrot.id)
    assert_equal 2, filtered.count
  end
  
  test "filter by an unused ingredient id" do
    unused_ing = ingredients(:unused_ingredient)
    assert_equal 0, Recipe.search_by_ingredient_id(unused_ing.id).count
  end
  
  test "filter by ingredient name (full, unique)" do
    #carrot appears twice in recipe1 and once in recipe 3
    carrot = ingredients(:carrot)
    filtered = Recipe.search_by_ingredient(carrot.name)
    assert_equal 2, filtered.count
  end
  
  test "filter by ingredient name (partial, unique)" do
    #carrot appears twice in recipe1 and once in recipe 3
    filtered = Recipe.search_by_ingredient("Carr")
    assert_equal 2, filtered.count
  end
  
  test "filter by ingredient name (partial, multiple)" do
    #carrot appears twice in recipe1 and once in recipe 3
    #rotted thing appears once in recipe 3 and once in recipe 4
    # - total of 3 appearences, therefore
    filtered = Recipe.search_by_ingredient("ot")
    assert_equal 3, filtered.count, "#{filtered.inspect}"
  end
  
  test "filter by case-insensitive ingredient name (partial, multiple)" do
    #'Rot' should match both carrot and rotted thing
    #carrot appears twice in recipe1 and once in recipe 3
    #rotted thing appears once in recipe 3 and once in recipe 4
    # - total of 3 appearences, therefore
    filtered = Recipe.search_by_ingredient("Rot")
    assert_equal 3, filtered.count, "#{filtered.inspect}"
  end
end
