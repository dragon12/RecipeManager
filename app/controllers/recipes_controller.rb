class RecipesController < ApplicationController

  include AuthenticationHelper
  
  #before_filter :authenticate, except: [:index, :show]

  #def authenticate
  #  authenticate_or_request_with_http_basic do |username, password|
  #    @authenticated = username == "foo" && password == "bar"
  #  end
  #end
#
#  def authenticated?
#    @authenticated
#  end
#  helper_method :authenticated?
  
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
    @recipes = @recipes.paginate(page: params[:page])
    render 'index'
  end
  
  def show
    @recipe = Recipe.find(params[:id])
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
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
                  :cooking_time, :rating, :portion_count, :_destroy,
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
         groups = ret_params["instruction_groups_attributes"]
         
         groups.each do |unused, group|
           empty = true
           if (group.has_key?("instructions_attributes"))
             insts = group["instructions_attributes"]
             
             #strip any that are not real and are blank
             insts.reject! {|unused2, inst| Instruction.is_params_empty(inst) && inst["id"].blank?}
             insts.each do |unused2, inst|
               empty = false
               
               logger.info("looking at instruction #{inst}")
               if Instruction.is_params_empty(inst)
                 logger.info("Is empty, marking for destruction")
                 inst[:_destroy] = "1"
               end
             end
           end
           if empty
             logger.info("group #{group[:name]} is empty, marking for destruction")
             group[:_destroy] = "1"
           end
         end
         
       end
#      if ret_params.has_key?("links_attributes")
#        ret_params[:links_attributes].reject!{|unused, a| 
#          a[:description].blank? && a[:url].blank? && a[:_destroy] == "false"
#          }
#      end
      
      #there has got to be a better way of doing this ...
#      if ret_params.has_key?("instruction_groups_attributes")
#        debugger
#         ret_params[:instruction_groups_attributes].reject! {|unused, ig|
#           logger.info(ig)
#           
#           all_removed = true
#           if ig.has_key?("instructions_attributes")
#             ig[:instructions_attributes].reject! {|unused2, ins|
#               all_removed = all_removed && (ins[:_destroy] == "true" || ins[:_destroy] == "1")
#               ins[:step_number].blank? && ins[:description].blank? && ins[:_destroy] == "false"
#               }
#           end
#           
#           #debugger
#           if !ig.has_key?("instructions_attributes") || ig[:instructions_attributes].empty? || all_removed
#             logger.info("doesnt' have instructions")
#             ig[:_destroy] = "1"
#           end
#           false
#           }
#      end
#      
#      if ret_params.has_key?("ingredient_quantity_groups_attributes")
#         ret_params[:ingredient_quantity_groups_attributes].reject! {|unused, iqg|
#           logger.info(iqg)
#        
#           all_removed = true
#           #debugger
#           if iqg.has_key?("ingredient_quantities_attributes")
#             iqg[:ingredient_quantities_attributes].reject! {|unused2, iq|
#               all_removed = all_removed && (iq[:_destroy] == "true" || iq[:_destroy] == "1")
#               iq[:quantity].blank? && iq[:preparation].blank? && iq[:ingredient_id].blank? && iq[:_destroy] == "false"
#               }
#             retval = retval && ig[:ingredient_quantities_attributes].empty?
#           end
#           
#           
#           if all_removed
#             logger.info("doesn't have ingredients")
#             iqg[:_destroy] = "1"
#           end
           
#           false
#         }
#      end
      logger.info ("after")
      logger.info(ret_params)
      return ret_params
      
    end
    
  
end
