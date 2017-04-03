class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: :true
  validates_presence_of :reservation
  validate :valid_reservation?

  def valid_reservation?
    if reservation != nil
      res_accepted = reservation.status == "accepted" 
      checked_out = reservation.checkout < Date.today
      if !res_accepted || !checked_out
        errors[:base] << "If you never checked in or never checked out, your review is no good."
      end
    end
  end

end
