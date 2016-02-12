class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def update_host_status(value)
    value == 1 ? self.host = true : self.host = false
    self.save
  end

  def guests
    reservations.map{|reservation| User.find_by(id: reservation.id)}
  end

  def hosts
    User.joins(:reservations).where("reservations.guest_id = ?", self.id).distinct
  end

  def host_reviews
    guests.map{|guest| guest.reviews}.flatten
  end
  

end
