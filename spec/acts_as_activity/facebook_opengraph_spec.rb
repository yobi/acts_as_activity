# https://github.com/cardinalblue/rest-more/blob/master/doc/tutorial/facebook.md

describe ActsAsActivity::FacebookOpengraph do
  #get facebook auth token
  #check config gets loaded

  it "should load rest-core.yml" do
    RestCore::Facebook.default_app_id.should eq('284257808271079')
  end

end
