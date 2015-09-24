describe Listing do
  describe 'attributes' do

    let(:listing) { Listing.new(title: 'Beautiful Apartment on Main Street',
                                description: "Whole house for rent on mountain. Many bedrooms.",
                                address: '123 Main Street',
                                listing_type: 'shared room',
                                price: 15.00) }

    it 'has a title' do 
      expect(listing.title).to eq("Beautiful Apartment on Main Street")
    end

    it 'has a description' do
      expect(listing.description).to eq("Whole house for rent on mountain. Many bedrooms.")
    end

    it 'has an address' do 
      expect(@listing1.address).to eq('123 Main Street')
    end

    it 'has a listing type' do 
      expect(@listing2.listing_type).to eq("shared room")
    end

    it 'has a price' do
      expect(@listing2.price).to eq(15.00)
    end
  end

  describe 'belongs_to associations' do
    let(:listing) { Listing.new }
    let(:host) { User.new }
    let(:neighborhood) { Neighborhood.new }

    it 'belongs to a neighborhood' do
      listing.neighborhood = neighborhood
      expect(listing.neighborhood).to eq(neighborhood)
    end

    it 'belongs to a host' do
      listing.host = host
      expect(listing.host).to eq(host)
    end
  end

  describe 'has_many associations' do
    let(:vacation)    { Reservation.create }
    let(:staycation)  { Reservation.create }
    let(:bart_simpson) { User.create }
    let(:lisa_simpson) { User.create }

    before :each do
      @listing = Listing.create(title: 'Beautiful Apartment on Main Street',
                                description: "Whole house for rent on mountain. Many bedrooms.",
                                neighborhood: Neighborhood.new,
                                address: '123 Main Street',
                                listing_type: 'shared room',
                                price: 15.00,
                                reservations: [vacation, staycation],
                                host: User.new)
    end

    it 'has many reservations' do
      expect(@listing.reservations).to include(vacation)
      expect(@listing.reservations).to include(staycation)
    end

    it 'has many guests' do
      @listing.guests = [bart_simpson, lisa_simpson]
      expect(@listing.guests).to include(bart_simpson)
      expect(@listing.guests).to include(lisa_simpson)
    end

    it 'has many reviews' do
      good_review = Review.create(guest: bart_simpson, reservation: vacation)
      reservation = Reservation.create(listing: @listing)
      expect(@listing.reviews).to include(good_review)
    end
  end

  describe 'listing validations' do
    let(:listing) { Listing.new }

    before :each do
      listing.valid?
    end

    it 'is invalid without an address' do
      expect(listing.errors.full_messages).to include "Address can't be blank"
    end

    it 'is invalid without a listing type' do
      expect(listing.errors.full_messages).to include "Listing type can't be blank"
    end

    it 'is invalid without a title' do
      expect(listing.errors.full_messages).to include "Title can't be blank"
    end

    it 'is invalid without a description' do
      expect(listing.errors.full_messages).to include "Description can't be blank"
    end

    it 'is invalid without a price' do
      expect(listing.errors.full_messages).to include "Price can't be blank"
    end

    it 'is invalid without an associated neighborhood' do 
      expect(listing.errors.full_messages).to include "Neighborhood can't be blank"
    end
  end

  describe 'callback methods' do
    let(:los_angelos) { City.create(name: "Los Angeles") }
    let(:santa_monica) { Neighborhood.create(name: 'Santa Monica', city: los_angelos) }

    context 'when listing created' do
      let(:user) { User.create(name: 'Tina Fey', host: false) }
      let(:other_user) { User.create(name: 'Not Tina Fey') }

      it 'changes user host status' do
        expect(user.host?).to eq(false)

        listing = Listing.create(address: '123 Main Street',
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user)
        expect(user.reload.host?).to eq(true)
      end
    end

    context "when some of a host's listings are destroyed" do
      let(:user) { User.create(name: 'Tina Fey', host: true) }
      let(:other_user) { User.create(name: 'Not Tina Fey') }

      let(:first_listing) { Listing.create(address: '123 Main Street',
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user) }
        let(:second_listing) { Listing.create(address: '123 Main Street',
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user) }
        let(:unrelated_listing) { Listing.create(address: '123 Main Street',
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user) }

        before :each do 
          first_listing
          second_listing
        end

      it 'does not change the host status to false' do
        expect(user.host?).to eq(true)
        first_listing.destroy
        expect(user.reload.host?).to eq(true)
      end
    end

    context "when all of a host's listings are destroyed" do
      let(:user) { User.create(name: 'Tina Fey', host: true) }
      let(:other_user) { User.create(name: 'Not Tina Fey') }

      let(:first_listing) { Listing.create(address: '123 Main Street', 
          listing_type: "private room",
          title: "Foo",
          description: "Foo",
          price: "150.00",
          neighborhood: santa_monica,
          host: user) }
        let(:second_listing) { Listing.create(address: '123 Main Street', 
          listing_type: "private room", 
          title: "Foo", 
          description: "Foo", 
          price: "150.00", 
          neighborhood: santa_monica, 
          host: user) } 
        let(:unrelated_listing) { Listing.create(address: '123 Main Street', 
          listing_type: "private room", 
          title: "Foo", 
          description: "Foo", 
          price: "150.00", 
          neighborhood: santa_monica, 
          host: user) } 

      it 'changes host status to false' do 
        expect(user.host).to eq(true)
        first_listing.destroy
        second_listing.destroy
        expect(user.reload.host?).to eq(false)
      end
    end
  end

  describe "#average_review_rating" do
    it 'knows its average ratings from its reviews' do
      friendly_manner = Neighborhood.create(name: "Boulevard Hieghts", city_id: City.last.id)
      host_with_the_most = User.create(name: "The Creator")
      guest_thats_the_best = User.create(name: "The Consumer")
      listing = Listing.create(address: '987 Main Street',
          listing_type: "entire place",
          title: "Luxury",
          description: "Cement block hut",
          price: 150.00,
          neighborhood_id: friendly_manner.id, 
          host_id: host_with_the_most.id)

      reserved1 = Reservation.create(checkin: '2015-09-15', checkout: '2015-09-18', listing_id: listing.id, guest_id: guest_thats_the_best.id, status: "accepted")
      reserved2 = Reservation.create(checkin: '2015-09-19', checkout: '2015-09-21', listing_id: listing.id, guest_id: 6, status: "accepted")

      first_review = Review.create(description: "Okish.", rating: 1, guest_id: guest_thats_the_best.id, reservation_id: reserved1.id)
      second_review = Review.create(description: "The 5 mounted moose heads were a bit much.", rating: 2, guest_id: 6, reservation_id: reserved2.id)
      
      expect(listing.average_review_rating).to eq(1.5)
    end
  end  
end
