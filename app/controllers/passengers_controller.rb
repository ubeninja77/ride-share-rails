class PassengersController < ApplicationController
  def index
    @passengers = Passenger.all
  end

  def show
    @passenger = Passenger.find_by(id: params[:id])
    if @passenger.nil?
    head :not_found 
    return
    end
  end

  def new
    @passenger = Passenger.new
  end

  def create
    @passenger = Passenger.new(passenger_params)

    if @passenger.save
      redirect_to passenger_path(@passenger.id)
      return
    else
      render new_passenger_path
      return
    end
  end

  def destroy
    @passenger = Passenger.find_by(id: params[:id])
    
    if passenger.nil?
      redirect_to passengers_path
      return
    else
      passenger.destroy
      redirect_to passengers_path
      return
    end
  end

  def edit
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      redirect_to passengers_path
      return
    end
  end

  def update
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      head :not_found
      return
    elsif @passenger.update(passenger_params)
      redirect_to passengers_path(@passenger.id)
      return
    else
      render :edit
    end
  end

  def update_trips
    @trips = Trip.where(passenger_id: @passenger.id)
    @trips.each do |trip|
      trip.passenger_id = 0
      trip.save
    end
  end

end
