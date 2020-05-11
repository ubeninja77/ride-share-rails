class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  def transform_to_dollars
    amount = self.cost.to_f / 100
    return amount
  end
end
