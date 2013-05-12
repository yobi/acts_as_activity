module ActsAsActivity
  class FacebookOpengraph
    def initialize( opts={} )
      @fb_client = RestCore::Facebook.new(:access_token => opts[:access_token])
      @fb_app_config = YAML.load_file("#{Rails.root}/config/rest-core.yml")[Rails.env]['facebook']
    end

    #https://graph.facebook.com/me/yobi-dev:vote_for&
    #access_token=ACCESS_TOKEN&
    #method=POST&
    #film=http://samples.ogp.me/525845907445600
    def post_story( fb_user_id, action, action_type, object )
      @fb_client.post("#{fb_user_id}/#{@fb_app_config['app_namespace']}:#{action}",
                      { action_type => "http://#{@fb_app_conifg['object_host']}#{object}" })
    end

    def delete_story( story_id )
      @fb_client.delete(story_id)
    end

    def self.object_host
      @fb_app_config['object_host']
    end

    def self.config_path
      "#{Rails.root}/config/rest-core.yml"
    end

    def self.config
      YAML.load_file("#{Rails.root}/config/rest-core.yml")[Rails.env]['facebook']
    end
  end
end
