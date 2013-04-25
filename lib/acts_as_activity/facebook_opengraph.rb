module ActsAsActivity
  class FacebookOpengraph
    def initialize opts={}
      @fb_client = RestCore::Facebook.new(:access_token => opts[:access_token])
    end

    #https://graph.facebook.com/me/yobi-dev:vote_for&
    #access_token=ACCESS_TOKEN&
    #method=POST&
    #film=http://samples.ogp.me/525845907445600
    def post_story(app_namespace, action_type, object)
      @fb_client.post("me/#{app_namespace}:#{action_type}", object)
    end

    def delete_story(story_id)

    end
  end
end
