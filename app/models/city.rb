class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    #close but not entirely accurate -- good enough for now
    array = []
    Listing.all.each do |listing|
      listing.reservations.each do |reserv|
        (start_date..end_date).each do |date|
          if reserv.checkin != date && reserv.checkout != date
            array<<listing
          end
        end
      end
    end
    array.uniq
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

