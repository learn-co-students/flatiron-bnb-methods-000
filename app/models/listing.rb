class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  validate :neighborhood_exist
  before_create :set_host
  before_destroy :check_host

  def average_review_rating
    rating_sum = 0
    reviews.each do |review|
      rating_sum = rating_sum + review.rating
    end
    rating_sum / reviews.count.round(2)
  end

  private

  def neighborhood_exist
    errors.add(:neighborhood_id, "Doesn't exist") unless Neighborhood.exists?(neighborhood_id)
  end

  def set_host
    host.host = true
    host.save
  end

  def check_host
    if host.listings.length == 1
      host.host = false
      host.save
    end
  end
  
end
