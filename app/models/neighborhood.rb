class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  include CommonCode

  def neighborhood_openings(date1, date2)
    booking_times = [date1.to_date..date2.to_date]
    rt = Reservation.arel_table
    where_clause = rt[:status].eq(:accepted).and((rt[:checkin].in(booking_times)).or(rt[:checkout].in(booking_times)))
    unavailable_listing_ids = []
    self.listings.map{|l| 
      l.reservations.where(where_clause).select(:listing_id).each{|i|
      #l.reservations.where(status: :accepted).where('(checkin BETWEEN ? AND ?) OR (checkout BETWEEN ? AND ?)', date1.to_date, date2.to_date, date1.to_date, date2.to_date).select(:listing_id).each{|i|
        unavailable_listing_ids << i.listing_id
      }
    }
    Listing.where.not(id: unavailable_listing_ids)
  end

  def self.reservations_numbers
    joins(listings: :reservations).group("neighborhoods.id").count
  end

  def self.listings_numbers
    joins(:listings).group("neighborhoods.id").count
  end

end
