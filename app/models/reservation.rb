class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  # before_create :listing
  # validates :checkin, less_than: :checkout
  # validates :listing_id, exclusion: { in: [self.guest_id] }

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end


end
