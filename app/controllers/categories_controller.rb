class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def update?
    authorize @user, :admin
    true
  end

  # GET /categories
  # GET /categories.json
  def index
    @q = Category.ransack(params[:q])
    @categories = @q.result(distinct: true)
    @categories = @categories.paginate(:page => params[:page], :per_page => 8)
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update

      @users = User.find_by_category_id(@category.id)

      respond_to do |format|

      if category_params[:status]=="inativo" and @category.status=="ativo" and @users!=nil
          format.html { redirect_to @category, notice: 'Categoria tem profissionais. Desative os profissionais.' }
          format.json { render :show, status: :ok, location: @category }
      else

        if @category.update(category_params)
          format.html { redirect_to @category, notice: 'Category was successfully updated.' }
          format.json { render :show, status: :ok, location: @category }
        else
          format.html { render :edit }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end

      end

    end

  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    
    @users = User.find_by_category_id(@category.id)

    respond_to do |format|
      if(@users!=nil)
        format.html { redirect_to categories_url, notice: 'Categoria tem profissionais. Destrua primeiro os profissionais.' }
        format.json { head :no_content }
      else
        @category.destroy
        format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :status, :foto)
    end
end
