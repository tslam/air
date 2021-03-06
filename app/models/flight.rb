class Flight < ActiveRecord::Base
  attr_accessible :number, :arrival_airport, :departs_at, :departure_airport, :seats

  # departure_airport_id: integer
  # belongs_to :departure_airport, :class_name => "Airport"

  scope :search, lambda { |keyword| Flight.where("LOWER(departure_airport) LIKE ? OR LOWER(arrival_airport) LIKE ?",
                                "%#{keyword}%", "%#{keyword}%") }

  # def self.from_chicago
  #   search('ORD')
  # end

  # def self.search(keyword)
  #   Flight.where("LOWER(departure_airport) LIKE ? OR LOWER(arrival_airport) LIKE ?",
  #                               "%#{keyword}%", "%#{keyword}%")
  # end

  DOMESTIC = 0
  INTL = 1

  def availability?
    self.seats > 0
  end

  MILEAGE_CHART = {
    "ORD JFK" => 740,
    "ORD LAX" => 1744,
    "ORD SFO" => 1846,
    "MDW JFK" => 740,
    "MDW LAX" => 1744,
    "MDW SFO" => 1846,
    "JFK LAX" => 2475,
    "JFK SFO" => 2586,
    "LAX SFO" => 338
  }

  def duration
    miles / 8
  end

  def miles
    distance = MILEAGE_CHART["#{self.departure_airport} #{self.arrival_airport}"]
    if distance.nil?
      distance = MILEAGE_CHART["#{self.arrival_airport} #{self.departure_airport}"]
    end
    distance
  end

  def arrives_at
    self.departs_at + duration.minutes
  end


end
