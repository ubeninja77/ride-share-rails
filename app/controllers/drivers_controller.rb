class DriversController < ApplicationController
  def index
    @drivers = Driver.all.order("created_at") # maintains order 
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

  def create # Set the availability status to true by default
    @driver = Driver.new(driver_params.merge(:available => 'true')) 

    if @driver.save 
      redirect_to driver_path(@driver.id)
      return
    else 
      render :new
      return
    end
  end

  def edit
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      redirect_to drivers_path
      return
    end
  end

  def update
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      redirect_to drivers_path
      return
    elsif @driver.update(driver_params)
      redirect_to driver_path(@driver.id) 
      return
    else 
      render :edit 
      return
    end
  end

  def destroy
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      redirect_to drivers_path
      return
    else
      @driver.destroy
      redirect_to drivers_path
    end
  end

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin, :available)
  end
end
