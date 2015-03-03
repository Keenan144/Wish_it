require '../spec_helper'
require 'faker'


describe "user login" do 
  
  before(:each) do 
    User.destroy_all
  end

  describe "adds a username and password" do 
    it "creates a new user" do 
      
      User.create({name: Faker::Name.first_name, password: "12345"})
      expect {
      User.count
      }.to be{1}

    end
  end


  describe "validates" do
    it "validates handle to be lowercase" do
      expect {
        User.create({name: Faker::Name.first_name, handle: Faker::Name.first_name.capitalize, password: "12345"})
      }.to_not change{User.count}
    end


    it "validates handle to be lowercase" do
      expect {
        User.create({name: Faker::Name.first_name, handle: Faker::Name.first_name.downcase, password: "12345"})
      }.to change{User.count}
    end


    it "validates password must exist" do
      expect {
        User.create({name: Faker::Name.first_name, handle: Faker::Name.first_name.downcase})
      }.to change{User.count}
    end
  end
end







