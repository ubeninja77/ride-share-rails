require "test_helper"

describe TripsController do  
  let(:driver) {
    Driver.create name: "Test Smith", vin: "ADADEVELOPERSACAD",
    available: "true"
  }
  let(:passenger) {
    Passenger.create name: "Test", phone_num: '123'
  }
  let(:trip) {
    new_trip = Trip.create driver_id: driver.id, passenger_id: passenger.id,
      date: "2020-05-11", cost: "123"
    new_trip
  }

  before (:each) {
    Trip.delete_all
    Passenger.delete_all
    Driver.delete_all
  }
  describe "show" do
    it "responds with success when showing an existing valid trip" do
      # Arrange
      driver.save
      passenger.save
      trip.save
      # Act
      get trip_path(trip.id)
      # Assert
      must_respond_with :success
    end

    it "responds with redirect with an invalid trip id" do
      # Act
      get trip_path(-1)
      # Assert
      must_respond_with :redirect
    end
  end

  describe "create" do
    it "can create a new trip with valid information accurately, and redirect" do
      # Arrange
      # Set up the form data
      trip_hash = {
        trip: {
        driver_id: driver.id, passenger_id: passenger.id,
        date: "2020-05-11", cost: "123"
        },
      }
      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count
      expect {
        post trips_path, params: trip_hash
      }.must_change "Trip.count", 1
      # Assert
      # Find the newly created Trip, and check that all its attributes match what was given in the form data
      # Check that the controller redirected the user
      new_trip = Trip.find_by(driver_id: trip_hash[:trip][:driver_id])
      expect(new_trip.passenger_id).must_equal trip_hash[:trip][:passenger_id]
      expect(new_trip.date).must_equal trip_hash[:trip][:date]
      expect(new_trip.rating).must_equal nil
      expect(new_trip.cost).must_equal trip_hash[:trip][:cost]

      must_redirect_to trip_path(new_trip.id)
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid trip" do
      # Act
      get edit_trip_path(trip.id)
      
      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing trip" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      # Act
      get edit_trip_path(-1)
      # Assert
      must_respond_with :redirect
    end
  end

  describe "update" do
    it "can update an existing trip with valid information accurately, and redirect" do
      # Arrange
      trip_hash = {
        trip: {
          rating: "4"
        },
      }
      # Act-Assert
      # Ensure that there is no change in Trip.count
      trip
        expect{
          patch trip_path(trip.id), params: trip_hash
        }.must_differ "Trip.count", 0
        expect (Trip.find_by(id: trip.id).rating ).must_equal "4"
    end
  end

  describe "destroy" do
    it "destroys the trip instance in db when trip exists, then redirects" do
      trip
      expect{ delete trip_path(trip.id)
      }.must_differ 'Trip.count', -1
      absent = Trip.find_by(id: trip.id)
      # Assert
      # Check that the controller redirects
      expect(absent).must_be_nil
      must_redirect_to passenger_path(trip.passenger_id)
    end

    it "does not change the db when the trip does not exist, then responds with redirect" do
      expect {
        delete trip_path(-1)
        }.must_differ 'Trip.count', 0
      must_redirect_to trips_path
    end
  end
end
