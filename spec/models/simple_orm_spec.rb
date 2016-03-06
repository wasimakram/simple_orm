require_relative "../../simple_orm.rb"
class Employee
  include SimpleOrm
end

class User
  include SimpleOrm
end

describe User do

  subject {User.new}

  describe "#all" do
    it "should be able to call all" do
      expect(subject).to respond_to(:all)
    end

    it "should return an array" do
      expect(subject.all.class).to eq(Array)
    end

  end

  describe "#find" do
    it "should be able to call find" do
      expect(subject).to respond_to(:find)
    end

    it "should return  the mixedin class's object" do
      expect(subject.find(1).class).to eq(User)
    end
  end
end


describe Employee do

  subject {Employee.new}

  describe "#all" do
    it "should be able to call all" do
      expect(subject).to respond_to(:all)
    end

    it "should return an array" do
      expect(subject.all.class).to eq(Array)
    end

  end

  describe "#find" do
    it "should be able to call find" do
      expect(subject).to respond_to(:find)
    end

    it "should return  the mixedin class's object" do
      expect(subject.find(1).class).to eq(Employee)
    end
  end
end
