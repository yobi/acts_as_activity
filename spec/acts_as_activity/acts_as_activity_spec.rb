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
      before(:each) do
        @contestant = create(:contestant)
      end

      it "should not auto create activity" do
        @contestant.activity.should == nil
      end

      it "should be indie" do
        contestant_2 = create(:contestant)
        contestant_2.create_activity!
        @contestant.create_activity.should_not eq(false)
        @contestant.create_activity!
      end

      it "should build a new activity" do
        activity = @contestant.create_activity
        activity.new_record?.should eq(true)
      end

      it "should build a new valid activity" do
        activity = @contestant.create_activity
        activity.valid?.should eq(true)
      end

      it "should not allow duplicate activities to be created" do
        @contestant.create_activity!
        @contestant.create_activity.should eq(false)
      end
    end

    context "automatically creating activities on callbacks" do
      it "should save a new activity" do
        voter = create(:user)
        contestant = create(:contestant)
        vote = Vote.create(contestant_id: contestant.id, user_id: voter.id, active: true)
        Activity.where(activity_type: Vote, activity_id: vote.id).count.should eq(1)
      end
    end
  end

  describe "updating activity" do
    context "manually updating activity" do
      before(:each) do
        @contestant = create(:contestant)
        @contestant.create_activity!
      end

      it "should update the activity to reflect the record's updates" do
        @contestant.title = "New Title"
        @contestant.save
        @contestant.update_activity!
        @contestant.activity.object.should eq("New Title")
      end

      it "should respect the when_active proc" do
        @contestant.published = false
        @contestant.save
        @contestant.update_activity!
        @contestant.activity.active?.should eq(false)
      end
    end

    context "automatically updating activity on callbacks" do
      it "should update activity" do
        voter = create(:user)
        contestant = create(:contestant)
        vote = Vote.create(contestant_id: contestant.id, user_id: voter.id, active: true)
        Activity.where(activity_type: Vote, activity_id: vote.id).count.should eq(1)
        vote.active = false
        vote.save
        vote.activity.active?.should eq(false)
      end
    end

    context "record is destroyed" do
      it "then should de-activate activity" do
        voter = create(:user)
        contestant = create(:contestant)
        vote = Vote.create(contestant_id: contestant.id, user_id: voter.id, active: true)
        activity = Activity.where(activity_type: Vote, activity_id: vote.id).first
        vote.destroy
        activity.reload.active.should eq(false)
      end
    end
  end

  context "activity model is embedded" do
    let(:post_user) { create(:user) }
    let(:comment_user) { create(:user) }
    let(:post) { Post.create(user_id: post_user.id, body: "This is a post") }
    let(:comment) { post.comments.build(user_id: comment_user.id, body: "This is a comment on a post") }
    it "should set embedded_in_type" do
      comment.save
      comment.activity.embedded_in_type.should == "Post"
    end

    it "should set embedded_in_id" do
      comment.save
      comment.activity.embedded_in_id.should == post.id.to_s
    end
  end
end
