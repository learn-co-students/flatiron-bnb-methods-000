class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    # binding.pry
  #   Listing.all.collect do |listing|
  #     if listing.
  end

  def self.highest_ratio_res_to_listings
    hash = {}
    all.each do |city|
      base_reservs = 0
      city.listings.each do |city_listing|
        reservs = city_listing.reservations.length
        base_reservs = base_reservs + reservs
      end
      hash[city.id] = base_reservs / city.listings.length.round(2)
    end
    highest_avg = hash.values.sort.last
    find_by(id: hash.key(highest_avg))
  end

  def self.most_res
    hash = {}
    all.each do |city|
      base_reservs = 0
      city.listings.each do |city_listing|
        reservs = city_listing.reservations.length
        base_reservs = base_reservs + reservs
      end
      hash[city.id] = base_reservs
    end
    most_listings = hash.values.sort.last
    find_by(id: hash.key(most_listings))
  end

end

