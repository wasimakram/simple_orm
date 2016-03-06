require_relative "../../simple_orm.rb"
class Employee
  include SimpleOrm
end

class User
  include SimpleOrm
end

describe SimpleOrm do
  describe User do

    let(:user) {User.new}

    describe "#all" do
      subject {user.all}
      it "should be able to call all" do
        expect(user).to respond_to(:all)
      end

      it "should return an array" do
        expect(subject.class).to eq(Array)
      end
    end

    describe "#find" do
      subject { user.find(1) }

      it "should be able to call find" do
        expect(user).to respond_to(:find)
      end

      it "should return the mixin class's object" do
        expect(subject.class).to eq(User)
      end

      it "should have data for user" do
        # TODO : populate test data
        expect(subject.id).to eq(1)
        expect(subject.user_type).to eq("SUPER ADMIN")
        expect(subject.username).to eq("admin")
        expect(subject.password).to eq("admin")
      end
    end

    describe "#column_names" do
      subject { user.column_names }
      it "should be able to call column_names" do
        expect(user).to respond_to(:column_names)
      end

      it "should return the Array of column names" do
        expect(subject.class).to eq(Array)
      end

      it "should have table column names" do
        # TODO : populate test data
        expect(subject).to eq([])
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

end
