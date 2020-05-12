class Driver < ApplicationRecord
  has_many :trips
  validates :name, presence: true
  # VIN is composed of 17 characters (digits and capital letters)
  validates :vin, presence: true

  def calculate_rating
    trips_with_rating = self.trips.where.not(rating: nil)
    trips_count = trips_with_rating.length
    if trips_count > 0
      rating = 0.0
      trips_with_rating.each do |trip|
        rating += trip.rating.to_i
      end
      average = rating / trips_count
    else
      average = 0
    end
    return average
  end

  def total_earnings
    trips_with_earnings = self.trips.where.not(cost: nil)
    earnings = 0
    trips_with_earnings.each do |trip|
      earnings += (trip.cost.to_i - 165) * 0.8 / 100
    end
    return earnings
  end

  def update_availability
    if self.available == 'false'
      self.available = 'true'
    else
      self.available = 'false'
    end
  end
end

