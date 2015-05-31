require 'will_paginate/array'

class RecipesController < ApplicationController
  before_action :setup_vars
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

  @is_admin = false
  
  def index
    @search_ingredient_base = IngredientBase.new
    @search_category = Category.new
    
    no_search = params[:submit_search_by_recipe_name].blank? &&
                params[:submit_search_by_ingredient_name].blank? &&
                params[:submit_search_by_ingredient_base_id].blank? &&
                params[:submit_search_by_category_id].blank?
                
    if (no_search || !params[:submit_search_by_recipe_name].blank?) && !params[:search_by_recipe_name].blank?
      name_stripped = params[:search_by_recipe_name].strip
      @recipes = Recipe.search_by_name(name_stripped).order("created_at DESC")
      @filtered_text = "name like '%s'" % name_stripped
    elsif (no_search || !params[:submit_search_by_ingredient_name].blank?) && !params[:search_by_ingredient_name].blank?
      @recipes = Recipe.search_by_ingredient_name(params[:search_by_ingredient_name]).order("created_at DESC")
      @filtered_text = "containing ingredients like '%s'" % params[:search_by_ingredient_name]
    elsif (no_search || !params[:submit_search_by_ingredient_base_id].blank?) && !params[:search_by_ingredient_base_id].blank?
      @recipes = Recipe.search_by_ingredient_base_id(params[:search_by_ingredient_base_id]).order("created_at DESC")
      @search_ingredient_base = IngredientBase.find(params[:search_by_ingredient_base_id])
      @filtered_text = "containing '%s'" % @search_ingredient_base.name
    elsif (no_search || !params[:submit_search_by_category_id].blank?) && !params[:search_by_category_id].blank?
      @recipes = Recipe.search_by_category_id(params[:search_by_category_id]).order("created_at DESC")
      @search_category = Category.find(params[:search_by_category_id])
      @filtered_text = "in category '%s'" % @search_category.name
    else
      #@recipes = Recipe.joins(:category).order('categories.name asc, name asc')
      @recipes = Recipe.order(:created_at).reverse
    end

    @recipes = sort_by(params[:sort_by], @recipes)
    unless params[:descending].blank?
      @recipes = @recipes.reverse
    end
    @recipes = @recipes.paginate(page: params[:page])
    render 'index'
  end
  
  def sort_by(sort_field, hash)
    if sort_field.blank?
      return hash
    end
    
    symbol_sort_field = sort_field.intern
    #logger.info("instance methods of recipe: #{Recipe.instance_methods(true).inspect}")
    if !Recipe.instance_methods(true).include?(symbol_sort_field)
      logger.info("Couldn't find instance method: #{sort_field}")
      return hash
    end
    
    logger.info("SORTING ARITY: #{Recipe.instance_method(symbol_sort_field).arity}")
    arity = Recipe.instance_method(symbol_sort_field).arity
    return hash.sort_by{|item|
        if arity == 0
          item.send sort_field
        else
          item.send sort_field, current_user
        end
      }
  end
  
  def show
    @recipe = Recipe.find(params[:id])
    setup_empty_user_rating
    if !@recipe.images.empty?
      @image_to_display = @recipe.images.first
    end
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
    setup_empty_user_rating
  end
  
  def update
#    render plain: params[:recipe].inspect
    
    @recipe = Recipe.find(params[:id])
# @recipe.update(recipe_params)
    if @recipe.update(recipe_params)
      redirect_to @recipe
    else
      render 'edit'
    end
  end
  
  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
   
    redirect_to recipes_path
  end

  def new
    #we create an empty recipe here so that there is always a 'recipe' variable available to the template
    @recipe = Recipe.new
    @is_component = false
    
    ur = @recipe.user_ratings.build(user_id: current_user.id)
    
    ingredient_group = @recipe.ingredient_quantity_groups.build(name: "Default")
    ingredient_group.ingredient_quantities << IngredientQuantity.new
    
    instruction_group = @recipe.instruction_groups.build(name: "Default")
    instruction_group.instructions << Instruction.new
  end
  
  def create
    #render plain: params[:recipe].inspect
 
    p = recipe_params
    @recipe = Recipe.new(p)
 
    #if @is_component
    #  ci = @recipe.build_complex_ingredient
    #  ci.build_ingredient_link
    #  logger.info("COMPLEX: built complex: #{@recipe.complex_ingredient.inspect}")
    #end 
    
    if @recipe.save
      redirect_to @recipe
    else
      logger.info("COMPLEX: redirect, is_component = #{@is_component}")
      render 'new'
    end
    
  end
  
  private
    def recipe_params
      ret_params = params.require(:recipe)
        .permit(:name, :description, :comments, :category_id, :total_time, :active_time, 
                  :is_recipe_component, :cooking_time, :portion_count, :_destroy,
                links_attributes: [:id, :description, :url, :_destroy],
                images_attributes: [:id, :description, :url, :_destroy],
                instruction_groups_attributes: [
                  :id,
                  :name,
                  :_destroy,
                  {:instructions_attributes => [
                    :id,
                    :step_number, 
                    :details,
                    :_destroy]
                  }
                ],
                ingredient_quantity_groups_attributes: [
                  :id,
                  :name,
                  :_destroy,
                  {:ingredient_quantities_attributes => [
                      :id, 
                      :quantity, 
                      :preparation,
                      :ingredient_name,
                      :ingredient_link_id,
                      {:ingredient => [:name, :id]},
                      {:ingredient_attributes => [:name, :id]},
                      :_destroy]
                    }
                  ]
                )
      if ret_params.has_key?("instruction_groups_attributes")
        instruction_groups = ret_params["instruction_groups_attributes"]
        
        instruction_groups = Recipe.filter_blank_instructions_from_groups(instruction_groups)
        
        ret_params["instruction_groups_attributes"] = instruction_groups;
      end

      if ret_params.has_key?("ingredient_quantity_groups_attributes")
        iq_groups = ret_params["ingredient_quantity_groups_attributes"]
        
        iq_groups = Recipe.filter_blank_ingredient_quantities_from_groups(iq_groups)
        
        ret_params["ingredient_quantity_groups_attributes"] = iq_groups
      end

      logger.info(ret_params)
      return ret_params
      
    end
    
  def setup_vars
    @sortable_table = 1
    @is_admin = current_user && current_user.is_admin?
  end
  
  def setup_empty_user_rating
    return unless current_user
    logger.info("USER_RATING: doing user rating stuff")
    @user_rating = @recipe.user_rating(current_user)
    logger.info("USER_RATING: found #{@user_rating.inspect}")
    return unless @user_rating.blank?
    
    logger.info("USER_RATING: creating new empty rating")
    @user_rating = UserRating.new(user: current_user, recipe: @recipe)
    logger.info("USER_RATING: created #{@user_rating}")
    #@recipe.user_ratings << @user_rating
    #@recipe.reload
    #logger.info("USER_RATING: created #{@recipe.user_rating(current_user).inspect}")
  end
  
  # Confirms an admin user.
  def admin_user
    unless @is_admin
      flash[:danger] = "Must be admin to modify recipes"
      redirect_to(recipes_url) 
    end
  end
end
