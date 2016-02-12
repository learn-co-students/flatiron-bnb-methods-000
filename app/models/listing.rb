class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
  
  before_save do
    host.update_host_status(1)
  end

  after_destroy do
    host.update_host_status(0) if host.listings.empty?
  end

  def average_review_rating
    review_ratings = self.reviews.pluck(:rating)
    review_ratings.inject(0, :+).to_f / review_ratings.size.to_f
  end

end
