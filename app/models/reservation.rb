class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: :true
  validate :host_listing?, :available_listing?, :valid_duration?

  def host_listing?
    if listing.host_id == guest_id
      errors[:base] << "NO! You cannot book your own listing!"
    end
  end

  def available_listing?
    ### why do i need this first if when validation for it is called, so bad, so redundant, i so want to understand
    if checkin != nil && checkout != nil
      listing.reservations.each{|possible_conflict|
        checkin_conflict = checkin > possible_conflict.checkin && checkin < possible_conflict.checkout
        checkout_conflict = checkout > possible_conflict.checkin && checkout < possible_conflict.checkout
        if checkin_conflict
          errors.add(:checkin, "NO! No checkin for you when someone else is there!")
        elsif checkout_conflict
          errors.add(:checkout, "NO! No stay for you when someone else checks in!") 
        end
      }
    end
  end

  def valid_duration?
    if checkin != nil && checkout != nil
      if checkin == checkout
        errors[:base] << "NO! This is not a one-day stay place!"
      elsif checkout < checkin
        errors[:base] << "No time traveling allowed!"
      end
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price.to_i * duration
  end

end
