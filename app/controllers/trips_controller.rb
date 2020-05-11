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
    if params[:passenger_id].nil?
      @trip =  Trip.new
    else
      passenger = Passenger.find_by(id: params[:passenger_id])
      @trip = passenger.trips.new
    end
  end
end
