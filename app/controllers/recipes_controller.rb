require 'will_paginate/array'

class RecipesController < ApplicationController
  before_action :setup_vars
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

  @is_admin = false
  
  def index
    @search_ingredient = Ingredient.new
    @search_category = Category.new
    
    if !params[:search_by_name].blank?
      @recipes = Recipe.search_by_name(params[:search_by_name]).order("created_at DESC")
      @filtered_text = "name like '%s'" % params[:search_by_name]
    elsif !params[:search_by_ingredient].blank?
      @recipes = Recipe.search_by_ingredient(params[:search_by_ingredient]).order("created_at DESC")
      @filtered_text = "containing ingredients like '%s'" % params[:search_by_ingredient]
    elsif !params[:search_by_ingredient_id].blank?
      @recipes = Recipe.search_by_ingredient_id(params[:search_by_ingredient_id]).order("created_at DESC")
      @search_ingredient = Ingredient.find(params[:search_by_ingredient_id])
      @filtered_text = "containing '%s'" % @search_ingredient.name
    elsif !params[:search_by_category_id].blank?
      @recipes = Recipe.search_by_category_id(params[:search_by_category_id]).order("created_at DESC")
      @search_category = Category.find(params[:search_by_category_id])
      @filtered_text = "in category '%s'" % @search_category.name
    else
      #@recipes = Recipe.joins(:category).order('categories.name asc, name asc')
      @recipes = Recipe.order(:created_at)
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
      return hash.order("created_at DESC")
    end
    #if (sort_field == "user_rating")
    #  return 
    #end
    logger.info("SORTING ARITY: #{Recipe.instance_method(sort_field).arity}")
    arity = Recipe.instance_method(sort_field).arity
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
    setup_empty_user_rating
    ingredient_group = @recipe.ingredient_quantity_groups.build(name: "Default")
    ingredient_group.ingredient_quantities << IngredientQuantity.new
    
    instruction_group = @recipe.instruction_groups.build(name: "Default")
    instruction_group.instructions << Instruction.new
  end
  
  def create
    #render plain: params[:recipe].inspect
    
    @recipe = Recipe.new(recipe_params)
 
    if @recipe.save
      redirect_to @recipe
    else
      render 'new'
    end
    
  end
  
  private
    def recipe_params
      ret_params = params.require(:recipe)
        .permit(:name, :description, :comments, :category_id, :total_time, :active_time, 
                  :cooking_time, :portion_count, :_destroy,
                links_attributes: [:id, :description, :url, :_destroy],
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
                      :ingredient_id,
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
    @is_admin = current_user && current_user.is_admin?
  end
  
  def setup_empty_user_rating
    return unless current_user
    logger.info("USER_RATING: doing user rating stuff")
    @user_rating = @recipe.user_rating(current_user)
    return unless @user_rating.blank?
    
    logger.info("USER_RATING: creating new empty rating")
    @user_rating = UserRating.new(user: current_user, recipe: @recipe)
    logger.info("USER_RATING: created #{@user_rating}")
    @recipe.user_ratings << @user_rating
    @recipe.reload
    logger.info("USER_RATING: created #{@recipe.user_rating(current_user).inspect}")
  end
  
  # Confirms an admin user.
  def admin_user
    unless @is_admin
      flash[:danger] = "Must be admin to modify recipes"
      redirect_to(recipes_url) 
    end
  end
end
