#coding: utf-8
require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @r1 = recipes(:recipe1)
    @r2 = recipes(:recipe2)
    @r3 = recipes(:recipe3)
    @recipe_one_group = recipes(:recipe2)
    @recipe_two_groups = recipes(:recipe1)
    @admin_user = users(:michael)
    @nonadmin_user = users(:archer)
    
  end
  
  test "recipe cost single group" do
    #we test the groups elsewhere
    cost = ingredient_quantity_groups(:group1_recipe2).cost;
    
    cost_str = "£%.2f" % cost
    assert_equal cost_str, @recipe_one_group.total_cost_str
  end
  
  test "recipe cost multiple groups" do
    #we test the groups elsewhere
    cost = ingredient_quantity_groups(:group1_recipe1).cost + 
            ingredient_quantity_groups(:group2_recipe1).cost 
    
    cost_str = "£%.2f" % cost
    assert_equal cost_str, @recipe_two_groups.total_cost_str
  end
  
  test "filter by category" do
    cat = categories(:food)
    
    filtered = Recipe.search_by_category_id(cat.id)
    
    assert_equal 3, filtered.count
  end
  
  test "filter by name" do
    #first three recipes are named 'Recipe %'
    filtered = Recipe.search_by_name("terrecipe")
    
    assert_equal 3, filtered.count
  end
  
  test "filter by ingredient id" do
    #carrot appears twice in recipe1 and once in recipe 3
    carrot = ingredient_bases(:carrot)
    filtered = Recipe.search_by_ingredient_base_id(carrot.id)
    assert_equal 2, filtered.count
  end
  
  test "filter by an unused ingredient id" do
    unused_ing = ingredient_bases(:unused)
    assert_equal 0, Recipe.search_by_ingredient_base_id(unused_ing.id).count
  end
  
  test "filter by ingredient name (full, unique)" do
    #carrot appears twice in recipe1 and once in recipe 3
    carrot = ingredient_links(:carrot)
    filtered = Recipe.search_by_ingredient_name(carrot.name)
    assert_equal 2, filtered.count
  end
  
  test "filter by ingredient name (partial, unique)" do
    #carrot appears twice in recipe1 and once in recipe 3
    filtered = Recipe.search_by_ingredient_name("Carr")
    assert_equal 2, filtered.count
  end
  
  test "filter by ingredient name (partial, multiple)" do
    #carrot appears twice in recipe1 and once in recipe 3
    #rotted thing appears once in recipe 3 and once in recipe 4
    # - total of 3 appearences, therefore
    filtered = Recipe.search_by_ingredient_name("ot")
    assert_equal 3, filtered.count, "#{filtered.inspect}"
  end
  
  test "filter by case-insensitive ingredient name (partial, multiple)" do
    #'Rot' should match both carrot and rotted thing
    #carrot appears twice in recipe1 and once in recipe 3
    #rotted thing appears once in recipe 3 and once in recipe 4
    # - total of 3 appearences, therefore
    filtered = Recipe.search_by_ingredient_name("Rot")
    assert_equal 3, filtered.count, "#{filtered.inspect}"
  end
  
  test "filter by updated since" do
    filtered = Recipe.search_by_updated_since("2015-02-28")
    assert_equal 3, filtered.count
  end
  
  test "strip blank ingredient_links no stripping" do
    groups_before = {
      "0" => {"id"=>"", 
              "name"=>"Default",
              "ingredient_quantities_attributes"=>{
                  "0"=>{
                      "id"=>"1", 
                      "quantity"=>"1", 
                      "ingredient_link_id"=>"1", 
                      "preparation"=>"", 
                      "_destroy"=>"false"
      }}}}
      
    groups_after = groups_before.deep_dup
    Recipe.filter_blank_ingredient_quantities_from_groups(groups_after)
    
    
    assert_equal groups_after, groups_before
  end
  
  
  test "strip blank ingredient_links one empty ingredient" do
    groups = {
      "0" => {:id =>"", 
              :name=>"Default",
              :ingredient_quantities_attributes=>{
                  "0"=>{
                      :id=>"1", 
                      :quantity=>"", 
                      :preparation=>"my_details",
                      :ingredient_link_id=>"1",
                      :_destroy=>"false"
                      },
                  "1"=>{
                      :id=>"", 
                      :quantity=>"", 
                      :preparation=>"",
                      :ingredient_link_id=>"",
                      :_destroy=>"false"
                      },
      }}}
    groups_expected = {
      "0" => {:id =>"", 
              :name=>"Default",
              :ingredient_quantities_attributes=>{
                  "0"=>{
                      :id=>"1", 
                      :quantity=>"", 
                      :preparation=>"my_details",
                      :ingredient_link_id=>"1",
                      :_destroy=>"false"
                      }
      }}}
    
    groups_after = Recipe.filter_blank_ingredient_quantities_from_groups(groups)
    
    assert groups_expected.with_indifferent_access == groups_after.with_indifferent_access, 
        "\nEXPECTED: #{groups_expected.inspect}\nSEEN: #{groups_after.inspect}"
  end
  
  
  test "strip blank ingredient quantities whole group empty" do
    groups = {
      "0" => {:id =>"", 
              :name=>"Default",
              :ingredient_quantities_attributes=>{
                  "0"=>{
                      :id=>"", 
                      :quantity=>"", 
                      :preparation=>"",
                      :ingredient_link_id=>"",
                      :_destroy=>"false"
                      },
                  "1"=>{
                      :id=>"", 
                      :quantity=>"", 
                      :preparation=>"",
                      :ingredient_link_id=>"",
                      :_destroy=>"false"
                      },
      }}}
      
    groups_expected = {
      "0" => {:id =>"", 
              :name=>"Default",
              :ingredient_quantities_attributes=>{},
              :_destroy=>"1"
              
              }}
    
    groups_after = Recipe.filter_blank_ingredient_quantities_from_groups(groups)
    
    assert groups_expected.with_indifferent_access == groups_after.with_indifferent_access, 
        "\nEXPECTED: #{groups_expected.inspect}\nSEEN: #{groups_after.inspect}"
  end
  
  
  test "strip blank ingredient quantities complex" do
    groups = {
      "0" => {:id =>"", 
              :name=>"Default1",
              :ingredient_quantities_attributes=>{
                  "0"=>{
                      :id=>"", 
                      :quantity=>"", 
                      :preparation=>"",
                      :ingredient_link_id=>"",
                      :_destroy=>"false"
                      },
                  "1"=>{
                      :id=>"1", 
                      :quantity=>"2", 
                      :preparation=>"prepared",
                      :ingredient_link_id=>"4",
                      :_destroy=>"false"
                      },
                    },
                  },
      "1" => {:id =>"", 
              :name=>"Default2",
              :ingredient_quantities_attributes=>{
                  "0"=>{
                      :id=>"", 
                      :quantity=>"", 
                      :preparation=>"",
                      :ingredient_link_id=>"",
                      :_destroy=>"false"
                      },
                  "1"=>{
                      :id=>"", 
                      :quantity=>"", 
                      :preparation=>"",
                      :ingredient_link_id=>"",
                      :_destroy=>"false"
                      },
                  },
              }
      }
    
      
    groups_expected = {
      "0" => {:id =>"", 
              :name=>"Default1",
              :ingredient_quantities_attributes=>{
                  "1"=>{
                      :id=>"1", 
                      :quantity=>"2", 
                      :preparation=>"prepared",
                      :ingredient_link_id=>"4",
                      :_destroy=>"false"
                      },
                    },
                 },
      "1" => {:id =>"", 
              :name=>"Default2",
              :ingredient_quantities_attributes=>{},
              :_destroy=>"1"
             },
          }
    
    
    groups_after = Recipe.filter_blank_ingredient_quantities_from_groups(groups)
    
    assert groups_expected.with_indifferent_access == groups_after.with_indifferent_access, 
        "\nEXPECTED: #{groups_expected.inspect}\nSEEN: #{groups_after.inspect}"
  end
  
  test "strip blank instructions no stripping" do
    groups_before = {
      "0" => {"id"=>"", 
              "name"=>"Default",
              "instructions_attributes"=>{
                  "0"=>{
                      "id"=>"1", 
                      "step_number"=>"1", 
                      "details"=>"my_details",
                      "_destroy"=>"false"
      }}}}
    
    groups_after = groups_before.deep_dup
    Recipe.filter_blank_instructions_from_groups(groups_after)
    
    assert_equal groups_after, groups_before
  end
  
  test "strip blank instructions one empty instruction" do
    groups = {
      "0" => {:id =>"", 
              :name=>"Default",
              :instructions_attributes=>{
                  "0"=>{
                      :id=>"1", 
                      :step_number=>"1", 
                      :details=>"my_details",
                      :_destroy=>"false"
                      },
                  "1"=>{
                      :id=>"", 
                      :step_number=>"", 
                      :details=>"",
                      :_destroy=>"false"
                      },
      }}}
    groups_expected = {
      "0" => {:id =>"", 
              :name=>"Default",
              :instructions_attributes=>{
                  "0"=>{
                      :id=>"1", 
                      :step_number=>"1", 
                      :details=>"my_details",
                      :_destroy=>"false"
                      }
      }}}
    
    groups_after = Recipe.filter_blank_instructions_from_groups(groups)
    
    assert groups_expected.with_indifferent_access == groups_after.with_indifferent_access, 
        "\nEXPECTED: #{groups_expected.inspect}\nSEEN: #{groups_after.inspect}"
  end
  
  
  test "strip blank instructions whole group empty" do
    groups = {
      "0" => {:id =>"", 
              :name=>"Default",
              :instructions_attributes=>{
                  "0"=>{
                      :id=>"", 
                      :step_number=>"", 
                      :details=>"",
                      :_destroy=>"false"
                      },
                  "1"=>{
                      :id=>"", 
                      :step_number=>"", 
                      :details=>"",
                      :_destroy=>"false"
                      },
      }}}
      
    groups_expected = {
      "0" => {:id =>"", 
              :name=>"Default",
              :instructions_attributes=>{},
              :_destroy=>"1"
              
              }}
    
    groups_after = Recipe.filter_blank_instructions_from_groups(groups)
    
    assert groups_expected.with_indifferent_access == groups_after.with_indifferent_access, 
        "\nEXPECTED: #{groups_expected.inspect}\nSEEN: #{groups_after.inspect}"
  end
  
  
  test "strip blank instructions complex" do
    groups = {
      "0" => {:id =>"", 
              :name=>"Default1",
              :instructions_attributes=>{
                  "0"=>{
                      :id=>"", 
                      :step_number=>"", 
                      :details=>"",
                      :_destroy=>"false"
                      },
                  "1"=>{
                      :id=>"1", 
                      :step_number=>"2", 
                      :details=>"3",
                      :_destroy=>"false"
                      },
                    },
                  },
      "1" => {:id =>"", 
              :name=>"Default2",
              :instructions_attributes=>{
                  "0"=>{
                      :id=>"", 
                      :step_number=>"", 
                      :details=>"",
                      :_destroy=>"false"
                      },
                  "1"=>{
                      :id=>"", 
                      :step_number=>"", 
                      :details=>"",
                      :_destroy=>"false"
                      },
                  },
              },
      "2" => {:id =>"", 
              :name=>"Default3",
                :instructions_attributes=>{
                    "0"=>{
                        :id=>"1", 
                        :step_number=>"2", 
                        :details=>"test",
                        :_destroy=>"true"
                        },
                    "1"=>{
                        :id=>"2", 
                        :step_number=>"3", 
                        :details=>"test2",
                        :_destroy=>"true"
                        },
                    },
                }
      }
    
      
    groups_expected = {
      "0" => {:id =>"", 
              :name=>"Default1",
              :instructions_attributes=>{
                  "1"=>{
                      :id=>"1", 
                      :step_number=>"2", 
                      :details=>"3",
                      :_destroy=>"false"
                      },
                    },
                 },
      "1" => {:id =>"", 
              :name=>"Default2",
              :instructions_attributes=>{},
              :_destroy=>"1"
             },
      "2" => {:id =>"", 
              :name=>"Default3",
              :instructions_attributes=>{
                    "0"=>{
                        :id=>"1", 
                        :step_number=>"2", 
                        :details=>"test",
                        :_destroy=>"1"
                        },
                    "1"=>{
                        :id=>"2", 
                        :step_number=>"3", 
                        :details=>"test2",
                        :_destroy=>"1"
                        },
                    },
              :_destroy=>"1"
         },
      }
    
    
    groups_after = Recipe.filter_blank_instructions_from_groups(groups)
    
    assert groups_expected.with_indifferent_access == groups_after.with_indifferent_access, 
        "\nEXPECTED: #{groups_expected.inspect}\nSEEN: #{groups_after.inspect}"
  end
  
  
  test "get user rating that doesn't exist in recipe with no rating" do
    assert_equal "N/A", @r1.rating_for_user(users(:michael))
  end
  
  test "get user rating that doesn't exist in recipe with rating" do
    assert_equal "N/A", @r2.rating_for_user(users(:michael))
  end
  
  test "get user rating that does exist in recipe with single rating" do
    assert_equal "10", @r2.rating_for_user(users(:archer))
  end
  
  test "get user rating that does exist in recipe with multiple ratings" do
    assert_equal "5", @r3.rating_for_user(users(:archer))
  end
  
  test "get average rating that doesn't exist" do
    r = recipes(:unrated_recipe)
    assert_equal "N/A", r.average_rating
  end
  
  test "get average rating for single rating" do
    #recipe2 has a single rating of 10
    r = recipes(:recipe2)
    assert_equal "10", r.average_rating
  end
  
  test "get average rating for multiple ratings" do
    #recipe3 has ratings of 5 and 7
    r = recipes(:recipe3)
    assert_equal "6", r.average_rating
  end
end
