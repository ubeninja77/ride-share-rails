require "test_helper"

describe PassengersController do

  describe "index" do
    # Arrange
    it "responds with succcess when a passenger is saved" do
      Passenger.create(name: "Chris Shepherd", phone_num: "4088316377")
    
    # Act
    get passengers_path
    expect(Passenger.count).must_equal 1
    end
    
    #Arrange

    #Act

    #Assert
  end

  describe "show" do
    #Arrange

    #Act

    #Assert
  end

  describe "new" do
    # Your tests go here
  end

  describe "create" do
    # Your tests go here
  end

  describe "edit" do
    # Your tests go here
  end

  describe "update" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
