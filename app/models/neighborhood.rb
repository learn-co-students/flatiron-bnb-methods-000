class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  #test for this method needs to be rewritten
  def neighborhood_openings(start_date, end_date)
    Listing.where(neighborhood_id: id)
  #wrong method, need to finish
  end

  def self.highest_ratio_res_to_listings
    hash = {}
    all.each do |nbh|
      base_reservs = 0
      if nbh.listings.length != 0
        nbh.listings.each do |nbh_listing|
          reservs = nbh_listing.reservations.length
          base_reservs = base_reservs + reservs
        end
        hash[nbh.id] = base_reservs / nbh.listings.length
      end
    end
    highest_avg = hash.values.sort.last
    find_by(id: hash.key(highest_avg))
  end

  def self.most_res
    hash = {}
    all.each do |nbh|
      base_reservs = 0
      if nbh.listings.length != 0
        nbh.listings.each do |nbh_listing|
          reservs = nbh_listing.reservations.length
          base_reservs = base_reservs + reservs
        end
        hash[nbh.id] = base_reservs 
      end
    end
    most_reservs = hash.values.sort.last
    find_by(id: hash.key(most_reservs))
  end

end

