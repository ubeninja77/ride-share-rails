class DriversController < ApplicationController
  def index
    @drivers = Driver.all
  end

  def show
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      redirect_to drivers_path
      return
    end
  end

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params) 

    if @driver.save 
      redirect_to driver_path(@driver.id)
      return
    else 
      render :new, :bad_request
      return
    end
  end

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin, :available)
  end
end
