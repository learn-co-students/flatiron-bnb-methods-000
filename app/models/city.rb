class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  include CommonCode

  def city_openings(date1, date2)
    booking_times = [date1.to_date..date2.to_date]
    conflicting_reservations = reservations - reservations.where(status: :accepted).where.not(checkin: booking_times, checkout: booking_times)
    listings - Listing.where(id: conflicting_reservations.map{|cr| cr.listing_id})
  end

  def self.reservations_numbers
    Reservation.joins(listing: {neighborhood: :city}).group("cities.id").count
  end

  def self.listings_numbers
    Listing.joins(neighborhood: :city).group("cities.id").count
  end

end

