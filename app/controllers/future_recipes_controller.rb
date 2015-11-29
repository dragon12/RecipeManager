require 'will_paginate/array'
class FutureRecipesController < ApplicationController
  before_action :setup_vars
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_future_recipe, only: [:show, :edit, :update, :destroy]

  @is_admin = false
  
  # GET /future_recipes
  # GET /future_recipes.json
  def index
    @search_category = Category.new
    @search_tag = Tag.new
    
    no_search = params[:submit_search_by_future_recipe_name].blank? &&
                params[:submit_search_by_website].blank? &&
                params[:submit_search_by_category_id].blank? &&
                params[:submit_search_by_tag_id].blank?
    
    if (no_search || !params[:submit_search_by_future_recipe_name].blank?) && !params[:search_by_future_recipe_name].blank?
      name_stripped = params[:search_by_future_recipe_name].strip
      @future_recipes = FutureRecipe.search_by_name(name_stripped).order("updated_at DESC")
      @filtered_text = "name like '%s'" % name_stripped
    elsif (no_search || !params[:submit_search_by_website].blank?) && !params[:search_by_website].blank?
      name_stripped = params[:search_by_website].strip
      @future_recipes = FutureRecipe.search_by_website(name_stripped)
      @filtered_text = "website like '%s'" % name_stripped

    elsif (no_search || !params[:submit_search_by_category_id].blank?) && !params[:search_by_category_id].blank?
      @future_recipes = FutureRecipe.search_by_category_id(params[:search_by_category_id]).order("updated_at DESC")
      @search_category = Category.find(params[:search_by_category_id])
      @filtered_text = "in category '%s'" % @search_category.name
    elsif (no_search || !params[:submit_search_by_tag_id].blank?) && !params[:search_by_tag_id].blank?
      @search_tag = Tag.find(params[:search_by_tag_id])
      @future_recipes = @search_tag.future_recipes
      @filtered_text = "in tag '%s'" % @search_tag.name
    else
      @future_recipes = FutureRecipe.order(:updated_at).reverse
    end

    @future_recipes = sort_by(params[:sort_by], @future_recipes)
    unless params[:descending].blank?
      @future_recipes = @future_recipes.reverse
    end
    @future_recipes = @future_recipes.paginate(page: params[:page])
    render 'index'
  end

  def sort_by(sort_field, hash)
    if sort_field.blank?
      return hash
    end
    
    symbol_sort_field = sort_field.intern
    #logger.info("instance methods of recipe: #{Recipe.instance_methods(true).inspect}")
    if !FutureRecipe.instance_methods(true).include?(symbol_sort_field)
      logger.info("Couldn't find instance method: #{sort_field}")
      return hash
    end
    
    logger.info("SORTING ARITY: #{FutureRecipe.instance_method(symbol_sort_field).arity}")
    arity = FutureRecipe.instance_method(symbol_sort_field).arity
    return hash.sort_by{|item|
        if arity == 0
          item.send sort_field
        else
          item.send sort_field, current_user
        end
      }
  end

  # GET /future_recipes/1
  # GET /future_recipes/1.json
  def show
  end
  
  # GET /future_recipes/new
  def new
    link = ""
    if (!params["new_link"].blank?)
      link = params["new_link"].strip
    end
    
    if !link.blank?
      #does it already exist?
      logger.info("checking if #{link} already exists")
      existing = FutureRecipe.find_by_link(link)
      if existing
        redirect_to edit_future_recipe_path(:id => existing)
      end
    end
    
    @future_recipe = FutureRecipe.new
    @future_recipe.link = link
  end

  # GET /future_recipes/1/edit
  def edit
  end

  # POST /future_recipes
  # POST /future_recipes.json
  def create
    @future_recipe = FutureRecipe.new(future_recipe_params)

    respond_to do |format|
      if @future_recipe.save
        
        format.html { redirect_to future_recipes_path, notice: 'Future link was successfully created.' }
        format.json { redirect_to future_recipes_path, status: :created, location: @future_recipe }
      else
        format.html { render :new }
        format.json { render json: @future_recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /future_recipes/1
  # PATCH/PUT /future_recipes/1.json
  def update
    respond_to do |format|
      if @future_recipe.update(future_recipe_params)
        format.html { redirect_to @future_recipe, notice: 'Future link was successfully updated.' }
        format.json { render :show, status: :ok, location: @future_recipe }
      else
        format.html { render :edit }
        format.json { render json: @future_recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /future_recipes/1
  # DELETE /future_recipes/1.json
  def destroy
    @future_recipe.destroy
    respond_to do |format|
      format.html { redirect_to future_recipes_url, notice: 'Future link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_future_recipe
      @future_recipe = FutureRecipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def future_recipe_params
      params.require(:future_recipe)
            .permit(:name, :link, :description, :category_id, { tag_ids:[] })
    end
    
    def setup_vars
      @is_admin = current_user && current_user.is_admin?
    end
  
      # Confirms an admin user.
    def admin_user
      unless @is_admin
        flash[:danger] = "Must be admin to modify recipes"
        redirect_to(recipes_url) 
      end
    end
  
end
