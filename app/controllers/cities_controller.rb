class CitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  # GET /cities
  # GET /cities.json
  def index
    @q = City.ransack(params[:q])
    @cities = @q.result(distinct: true)
    @cities = @cities.paginate(:page => params[:page], :per_page => 8)
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
  end

  # GET /cities/new
  def new
    @city = City.new
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)

    @city.status="inativo"

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update

    @users = User.find_by_city_id(@city.id)

    respond_to do |format|
      if city_params[:status]=="inativo" and @city.status=="ativo" and @users!=nil
        format.html { redirect_to @city, notice: 'Cidade tem profissionais. Desative os profissionais.' }
          format.json { render :show, status: :ok, location: @city }
      else

        if @city.update(city_params)
          format.html { redirect_to @city, notice: 'City was successfully updated.' }
          format.json { render :show, status: :ok, location: @city }
        else
          format.html { render :edit }
          format.json { render json: @city.errors, status: :unprocessable_entity }
        end

      end
    end

  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy

    @users = User.find_by_city_id(@city.id)

    respond_to do |format|
      if(@users!=nil)
        format.html { redirect_to cities_url, notice: 'Cidade tem profissionais. Destrua primeiro os profissionais.' }
        format.json { head :no_content }
      else
        @city.destroy
        format.html { redirect_to cities_url, notice: 'City was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name, :state_id, :status)
    end
end
