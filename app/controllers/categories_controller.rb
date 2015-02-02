class CategoriesController < ApplicationController
  include AuthenticationHelper

  def index
    @categories = Category.order(:name)
  
    @category = Category.new
  end
  def create
    #render plain: params[:recipe].inspect
    
    @category = Category.new(category_params)
 
    if @category.save
      redirect_to action: "index"
    else
      @categorys = Category.order(:name)
      render 'index'
    end
  end
  
  def show
    @categories = Category.order(:name)
    @category = Category.find(params[:id])
    render 'index'
  end
  
  def update
#    render plain: params[:recipe].inspect
    
    @category = Category.find(params[:id])

    if @category.update(category_params)
      redirect_to categories_path
    else
      @categories = Category.order(:name)
      render 'index'
    end
  end
  
  def destroy
    @deleted_category = Category.find(params[:id])
    if @deleted_category.destroy
      #redirect_to categorys_path
      message = @deleted_category.name + " deleted successfully"
      redirect_to categories_path, :notice => message
    else
      message = @deleted_category.name + " couldn't be deleted: #{@deleted_category.errors[:base].first.to_s}"
      redirect_to categories_path, :alert => message
      #@categorys = category.order(:name)
      #@category = category.new
      #render 'index'
    end
   
  end
  
private

  def category_params
    return params.require(:category).permit(:name)
  end
  
end
