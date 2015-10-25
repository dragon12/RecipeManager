require 'will_paginate/array'
class FutureRecipesController < ApplicationController
  before_action :setup_vars
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_future_recipe, only: [:show, :edit, :update, :destroy]

  @is_admin = false
  
  # GET /future_recipes
  # GET /future_recipes.json
  def index
    @future_recipes = FutureRecipe.all.paginate(page: params[:page], :per_page => 30)
    render 'index'
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
      params.require(:future_recipe).permit(:name, :link, :description, :category_id, { tag_ids:[] })
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
