class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations

  def host_reviews
    array =[]
    guests.each do |guest|
      array << guest.reviews
    end
    array.flatten
  end

  #would love to know how to do below with association
  def hosts
    trips.each_with_object([]) do |trip, array|
      array << trip.listing.host
    end
  end


  
end
