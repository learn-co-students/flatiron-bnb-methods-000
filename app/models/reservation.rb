class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  before_validation :checktimes, :listing_owner, :availability

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  private

  def checktimes
    unless checkin != nil && checkout != nil && checkin < checkout
      return false
    end
  end

  def listing_owner
    if User.find_by(id:guest_id).listings.include?(listing)
      return false
    end
  end

  def availability
    if listing.reservations.length != 0 && listing.reservations.length != nil
      listing.reservations.each do |reserv|
        (reserv.checkin..reserv.checkout).each do |date|
          if checkin == date || checkout == date
            return false
          end
        end
      end
    end
  end

end
