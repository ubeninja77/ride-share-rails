require "test_helper"

describe PassengersController do
  let (:passenger) {
    Passenger.create name: "Jane Smith", phone_num: "408.831.6377"
  }

  describe "index" do
    # Arrange
    it "responds with succcess when a passenger is saved" do
      Passenger.create(name: "Jane Smith", phone_num: "408.831.6377")
    
    # Act
    get passengers_path

    # Assert
    must_respond_with :success
    end
    
    it "responds with success when there are no passengers are saved" do
      # Arrange

      # Act
      get passengers_path

      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing passenger" do
      # Arrange
      valid_passenger = Passenger.create(name: "Jane Smith", phone_num: "408.831.6377")

      # Act
      get passenger_path(valid_passenger.id)

      # Assert
      must_respond_with :success
    end

    it "responds with a not found error when id given is invalid message" do
      # Arrange
      valid_passenger = Passenger.create(name: "Jane Smith", phone_num: "408.831.6377")

      # Act
      get passenger_path("-1")

      # Assert
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success" do
      # Arrange

      # Act
        get new_passenger_path

      # Assert
        must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new passenger with valid information, then redirects to the passenger page" do
      # Arrange
      passenger_hash = {passenger: {name: "Jane Smith", phone_num: "408.831.6377"}}

      # Act/Assert
      expect {
        post passengers_path, params: passenger_hash}.must_differ 'Passenger.count', 1

        new_passenger_id = Passenger.find_by(name:"Jane Smith").id

        # Assert
        must_redirect_to passenger_path(new_passenger_id)
    end

    it "does not create a new passenger without valid information; then redirects" do
  
      # Arrange
      invalid_passenger_hash = {passenger: {phone_num: "408.831.6377"}}
      invalid_passenger_hash_2 = {passenger: {name: "Jane Smith"}}

      # Act/Assert
      expect {post passengers_path, params: invalid_passenger_hash}.must_differ 'Passenger.count', 0

      # Assert
      must_respond_with :success
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing passenger" do

      # Arrange
      get edit_passenger_path(passenger.id)

      # Assert
      must_respond_with :success
    end

    it "responds with not-found when trying to edit a passanger that does not exist" do

      # Arrange
      get edit_passenger_path(-77)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "can update an existing passenger with valid information accurately; then redirects" do
    
    end
  end

  describe "destroy" do
    it "destroys the passenger instance in the database when passenger exists; then redirects" do
      test_passenger = Passenger.create(name: "Jane Smith", phone_num: "408.831.6377")
    
      new_passenger = Passenger.find_by(id: test_passenger.id)

      expect {delete passenger_path(new_passenger.id) }.must_differ 'Passenger.count', -1

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "does not change the passenger database if the passenger does not exist; then responds with a redirect to the passenger page " do
      expect {delete passenger_path(0)}.wont_change 'Passenger.count'

      must_respond_with :redirect
      must_redirect_to passengers_path
    end
  end
end
