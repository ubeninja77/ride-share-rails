class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  def transform_to_dollars
    amount = self.cost.to_f / 100
    return amount
  end

  def assign_driver
    Driver.all.each do |driver|
      if driver.available == 'true'
        driver.available = 'false'
        return driver
      end
    end
  end

  def calculate_cost
    # trip cost in dollars
    return rand(5.5..199.99)
  end
end
