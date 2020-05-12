class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  def self.assign_driver
    Driver.all.each do |driver|
      if driver.available == 'true'
        driver.available = 'false'
        return driver
      end
    end
  end

  def calculate_cost
    # trip cost in dollars
    return rand(500..19999)
  end

  def self.create_new(passenger)
    trip = Trip.new
    trip.date = Date.today
    trip.cost = trip.calculate_cost
    trip.driver_id = self.assign_driver.id
    trip.passenger = passenger
    return trip
  end
end
