class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  before_validation :check_reservation

  private

  def check_reservation
    if reservation_id != true || reservation.status != "accepted" || reservation.checkout > Date.today
      return false
    end
  end

end
