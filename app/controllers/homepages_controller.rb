class HomepagesController < ApplicationController
  def index

    def index
      @passengers = Passenger.all
    end
  
    def show
      passenger_id = params[:id].to_i
      @passenger = Passenger.find_by(id: passenger_id)
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
  
    def edit
      @passenger = Passenger.find_by(id: params[:id])
  
      if @passenger.nil?
        redirect_to root_path
        return
      end
    end 

    def update
      @passenger = Passenger.find_by(id: params[:id] )
      if @passenger.nil?
        head :not_found
        return
      end
  
      if @passenger.update(passenger_params)
        redirect_to passenger_path(@passenger.id)
        return
      else
        redirect_to edit_passenger_path
        return
      end
    end
  
    def destroy
      passenger = Passenger.find_by( id: params[:id] )
  
      if passenger.nil?
        redirect_to passengers_path
        return
      else
        passenger.destroy
        redirect_to root_path
        return
      end
    end
  
  
  
  # private
  # def passenger_params
  #   return params.require(:passenger).permit(:name, :phone_num)
  # end


  end
end
