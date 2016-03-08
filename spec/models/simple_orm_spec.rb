require_relative "../../simple_orm.rb"
class Employee
  include SimpleOrm
end

class User
  include SimpleOrm
  has_one :employee
end

describe SimpleOrm do
  # TODO have a test db for SimpleOrm
  describe User do

    let(:test_class) { User }
    let(:test_column_names) { ["id", "employee_id", "user_type", "username", "password"] }

    describe "#employee" do
      it "respond to method employee" do
        subject { test_class.find(2).employee }

        expect(subject).to respond_to(:employee)
      end

      context "when no employee is present" do
        subject { test_class.find(1).employee }

        it { should be_nil }
      end

      context "when employee is present" do
        subject { test_class.find(2).employee }

        it { should be_instance_of(Employee) }
      end
    end

    describe ".find" do
      subject { test_class.find(1) }
      it "be able to call find" do
        expect(test_class).to respond_to(:find)
      end

      it "be able to call find" do
        expect(test_class).to respond_to(:find)
      end

      it "return the mixin class's object" do
        expect(subject.class).to eq(test_class)
      end

      it "have data for user" do
        # TODO : populate test data using fixtures
        expect(subject.id).to eq(1)
        expect(subject.user_type).to eq("SUPER ADMIN")
        expect(subject.username).to eq("admin")
        expect(subject.password).to eq("admin")
      end
    end

    describe ".all" do
      subject { test_class.all }
      it "be able to call all" do
        expect(test_class).to respond_to(:all)
      end

      it "return an array" do
        expect(subject.class).to eq(Array)
      end

      it "return a list of all users" do
        test_array = []
        (1..7).each do |index|
          test_array << test_class.find(index).to_h
        end
        expect(subject.map(&:to_h)).to eq(test_array)
      end
    end

    describe ".first" do
      xit "be able to call first"
    end

    describe ".order" do
      xit "be able to call order"
    end


    describe ".column_names" do
      subject { test_class.column_names }
      it "be able to call column_names" do
        expect(test_class).to respond_to(:column_names)
      end

      it "return the Array of column names" do
        expect(subject.class).to eq(Array)
      end

      it "have table column names" do
        expect(subject).to eq(test_column_names)
      end
    end
  end


  describe Employee do

    subject { Employee }

    describe "#all" do
      it "be able to call all" do
        expect(subject).to respond_to(:all)
      end

      it "return an array" do
        expect(subject.all.class).to eq(Array)
      end

    end

    describe "#find" do
      it "be able to call find" do
        expect(subject).to respond_to(:find)
      end

      it "return  the mixedin class's object" do
        expect(subject.find(1).class).to eq(Employee)
      end
    end
  end

end
