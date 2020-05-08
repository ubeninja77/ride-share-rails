class Passenger < ApplicationRecord
  validates :name, presence: true
  validates :phone_num, presence: true
  has_many :trips



  def total_paid
    total = 0
    self.trips.each do |trip|
      total += trip.cost.to_f
    end
  
    return total
  end
end
