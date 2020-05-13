require "test_helper"

describe DriversController do
  # Note: If any of these tests have names that conflict with either the requirements or your team's decisions, feel empowered to change the test names. For example, if a given test name says "responds with 404" but your team's decision is to respond with redirect, please change the test name.
  let (:driver) {
    Driver.create name: "Test Smith", vin: "ADADEVELOPERSACAD",
    available: "true"
  }
  before (:each) {
    Trip.delete_all
    Passenger.delete_all
    Driver.delete_all
  }

  describe "index" do
    it "responds with success when there are many drivers saved" do
      # Arrange
      # Ensure that there is at least one Driver saved
      driver.save
      # Act
      get drivers_path
      
      # Assert
      must_respond_with :success
    end

    it "responds with success when there are no drivers saved" do
      # Arrange
      # Ensure that there are zero drivers saved
      drivers = Driver.all
      expect(drivers.length).must_equal 0
      # Act
      get drivers_path
      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid driver" do
      # Arrange
      # Ensure that there is a driver saved
      driver.save
      # Act
      get driver_path(driver.id)
      # Assert
      must_respond_with :success
    end

    it "responds with redirect with an invalid driver id" do
      # Arrange
      # Ensure that there is an id that points to no driver

      # Act
      get driver_path(-1)
      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "responds with success" do
      # Act
      get new_driver_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new driver with valid information accurately, and redirect" do
      # Arrange
      # Set up the form data
      driver_hash = {
        driver: {
          name: "Test Test",
          vin: "12345678901234567",
        },
      }

      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count
      expect {
        post drivers_path, params: driver_hash
      }.must_change "Driver.count", 1
      # Assert
      # Find the newly created Driver, and check that all its attributes match what was given in the form data
      # Check that the controller redirected the user
      new_driver = Driver.find_by(name: driver_hash[:driver][:name])
      expect(new_driver.vin).must_equal driver_hash[:driver][:vin]
      expect(new_driver.available).must_equal 'true'
      
      must_redirect_to driver_path(new_driver.id)
    end

    it "does not create a driver if the form data violates Driver validations, and responds with not_found" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates Driver validations
      driver_hash = {
        driver: {
          name: "Test",
          vin: "",
        },
      }
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        post drivers_path, params: driver_hash
      }.must_differ "Driver.count", 0
      # Assert
      # Check that the controller redirects
      must_respond_with :not_found
    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      # Arrange
      # Ensure there is an existing driver saved
      Driver.create(name: "Driver 100", vin: "123")
      # Act
      driver = Driver.last
      get edit_driver_path(driver.id)
      
      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      # Act
      get edit_driver_path(-1)
      # Assert
      must_respond_with :redirect
    end
  end

  describe "update" do
    it "can update an existing driver with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data
      driver1 = Driver.create(name: "Driver 100", vin: "123")
      driver_id = driver1.id
      driver_hash = {
        driver: {
          name: "Test",
          vin: "5",
        },
      }
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(driver1.id), params: driver_hash
        }.must_differ 'Driver.count', 0
      # Assert
      # Use the local variable of an existing driver's id to find the driver again, and check that its attributes are updated
      # Check that the controller redirected the user
      must_redirect_to driver_path
      edited_driver = Driver.find_by(id: driver_id)
      expect(edited_driver.name).must_equal driver_hash[:driver][:name]
      expect(edited_driver.vin).must_equal driver_hash[:driver][:vin]
    end

    it "does not update any driver if given an invalid id, and redirects" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      # Set up the form data
      nonexistant_driver = Driver.find_by(id: -1)
      expect(nonexistant_driver).must_be_nil
      driver_hash = {
        driver: {
          name: "Test",
          vin: "5",
        },
      }
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect{
        patch driver_path(-1), params: driver_hash
      }.must_differ 'Driver.count', 0
      # Assert
      # Check that the controller redirects
      must_redirect_to drivers_path
    end

    it "does not create a driver if the form data violates Driver validations, and responds with not_found" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data so that it violates Driver validations
      driver1 = Driver.create(name: "Driver 100", vin: "123")
      driver_hash = {
        driver: {
          name: "",
          vin: "",
        },
      }

      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect{
        patch driver_path(driver1.id), params: driver_hash
      }.must_differ 'Driver.count', 0

      # Assert
      # Check that the controller responds with not_found
      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it "destroys the driver instance in db when driver exists, then redirects" do
      # Arrange
      # Ensure there is an existing driver saved
      new_driver = Driver.create(name: "Driver 100", vin: "123")
      # Act-Assert
      # Ensure that there is a change of -1 in Driver.count
      expect {
        delete driver_path(new_driver.id)
        }.must_differ 'Driver.count', -1
      absent = Driver.find_by(id: new_driver.id)
      # Assert
      # Check that the controller redirects
      expect(absent).must_be_nil
      must_redirect_to drivers_path
    end

    it "does not change the db when the driver does not exist, then responds with redirect" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      invalid_id = -1
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        delete driver_path(invalid_id)
        }.must_differ 'Driver.count', 0
      # Assert
      # Check that the controller responds or redirects with whatever your group decides
      must_redirect_to drivers_path
    end
  end
end
