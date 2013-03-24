require File.expand_path('../../spec_helper', __FILE__)

describe ActsAsActivity do
  it "should provide class method 'activity?' that is false for non activity models" do
    User.should_not be_an_activity
  end

  describe "instance method generation" do
    it "should respond 'true' to activity?" do
      Contestant.should be_an_activity
    end

    it "should create instance method create_activity" do
      Contestant.new.should respond_to(:create_activity)
    end
  end

  describe "creating activities" do
    context "manually creating activity" do
      it "should build a new activity" do
        contestant = create(:contestant)
      end
    end

    context "automatically creating activities on callbacks" do

    end
  end
end
