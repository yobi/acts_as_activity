require File.expand_path('../../../spec_helper', __FILE__)

describe Activity do
  describe "facebook ogp callbacks" do
    let(:fb_ogp) { double("ActsAsActivity::FacebookOpengraph") }
    let(:voter) { create(:fb_user) }
    let(:contestant) { create(:contestant) }

    context "when activity is created" do
      it "should initialize a facebook opengraph client" do
        fb_ogp.stub(:post_story) { {id: "12345"} }
        ActsAsActivity::FacebookOpengraph.should_receive(:new)
          .with(access_token: voter.facebook_access_token)
          .and_return(fb_ogp)
        vote = Vote.create(contestant_id: contestant.id, user_id: voter.id, active: true)
      end

      it "should post the activity story" do
        ActsAsActivity::FacebookOpengraph.stub!(:new).with(access_token: voter.facebook_access_token).and_return(fb_ogp)
        fb_ogp.should_receive(:post_story)
          .with(voter.facebook_id, :vote_for, { :artist => "/#{contestant.contest.name.downcase}/contestant/#{contestant.user.screenname.downcase}" })
          .and_return({ "id" => "123456789"})
        vote = Vote.create(contestant_id: contestant.id, user_id: voter.id, active: true)
      end

      it "should save story id" do
        ActsAsActivity::FacebookOpengraph.stub!(:new).with(access_token: voter.facebook_access_token).and_return(fb_ogp)
        fb_ogp.stub(:post_story) { {"id" => "12345"} }
        vote = Vote.create(contestant_id: contestant.id, user_id: voter.id, active: true)
        vote.activity.ogp_story_id.should == "12345"
      end
    end

    context "when activity is destroy" do
      it "should delete the activity" do
        ActsAsActivity::FacebookOpengraph.stub!(:new).with(access_token: voter.facebook_access_token).and_return(fb_ogp)
        fb_ogp.stub(:post_story) { {"id" => "12345"} }
        vote = Vote.create(contestant_id: contestant.id, user_id: voter.id, active: true)
        fb_ogp.should_receive(:delete_story)
          .with("12345")
          .and_return(true)
        vote.destroy
      end
    end
  end
end
