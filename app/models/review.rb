class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  before_validation :check_reservation
  validates :rating, :description, presence: true

  private

  def check_reservation
    if reservation_id == nil || reservation.status != "accepted" || reservation.checkout > Date.today
      return false
    end
  end

end
