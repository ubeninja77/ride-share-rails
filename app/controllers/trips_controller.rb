class TripsController < ApplicationController
  def index
    if params[:passenger_id]
      # This is the nested route, /passenger/:passenger_id/trips
      @passenger = Passenger.find_by(id: params[:passenger_id])
      @trips = @passenger.trips
    # elsif params[:passenger_id].nil?
    #   redirect_to trips_path
    else
      # This is the 'regular' route, /trips
      @trips = Trip.all
    end
  end

  def show
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      redirect_to trips_path
      return
    end
  end

  def new
    passenger = nil
    if !params[:passenger_id].nil?
      passenger = Passenger.find_by(id: params[:passenger_id])
    end
    @trip = Trip.create_new(passenger)
  end

  def create
    @trip = Trip.new(trip_params.merge(:rating => nil)) 
    @trip.driver.update_availability
    @trip.driver.save

    if @trip.save 
      redirect_to trip_path(@trip.id)
      return
    else 
      render :new
      return
    end
  end

  def edit
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      redirect_to trips_path
      return
    end
    @trip
  end

  def update
    @trip = Trip.find_by(id: params[:id])
    if @trip.nil?
      redirect_to trips_path
      return
    elsif @trip.update(trip_params)
      redirect_to trip_path(@trip.id)
      @trip.driver.update_availability
      @trip.driver.save   
      return
    else 
      render :edit 
      return
    end
  end

  def destroy
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      redirect_to trips_path
      return
    else
      @trip.destroy
      redirect_to passenger_trips_path(@trip.passenger_id)
    end
  end


  def trip_params
    return params.require(:trip).permit(:driver_id, :passenger_id, :date, :rating, :cost)
  end
end
