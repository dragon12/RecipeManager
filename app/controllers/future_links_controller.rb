class FutureLinksController < ApplicationController
  before_action :setup_vars
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_future_link, only: [:show, :edit, :update, :destroy]

  @is_admin = false
  
  # GET /future_links
  # GET /future_links.json
  def index
    @future_links = FutureLink.all
  end

  # GET /future_links/1
  # GET /future_links/1.json
  def show
  end
  
  # GET /future_links/new
  def new
    link = ""
    if (!params["new_link"].blank?)
      link = params["new_link"].strip
    end
    
    if !link.blank?
      #does it already exist?
      logger.info("checking if #{link} already exists")
      existing = FutureLink.find_by_link(link)
      if existing
        redirect_to future_link_edit_path(:id => existing)
      end
    end
    
    @future_link = FutureLink.new
    @future_link.link = link
  end

  # GET /future_links/1/edit
  def edit
  end

  # POST /future_links
  # POST /future_links.json
  def create
    @future_link = FutureLink.new(future_link_params)

    respond_to do |format|
      if @future_link.save
        format.html { redirect_to @future_link, notice: 'Future link was successfully created.' }
        format.json { render :show, status: :created, location: @future_link }
      else
        format.html { render :new }
        format.json { render json: @future_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /future_links/1
  # PATCH/PUT /future_links/1.json
  def update
    respond_to do |format|
      if @future_link.update(future_link_params)
        format.html { redirect_to @future_link, notice: 'Future link was successfully updated.' }
        format.json { render :show, status: :ok, location: @future_link }
      else
        format.html { render :edit }
        format.json { render json: @future_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /future_links/1
  # DELETE /future_links/1.json
  def destroy
    @future_link.destroy
    respond_to do |format|
      format.html { redirect_to future_links_url, notice: 'Future link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_future_link
      @future_link = FutureLink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def future_link_params
      params.require(:future_link).permit(:name, :link, :description)
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
