require 'json'
require 'net/http'

module Notification
  class PushBullet
    def initialize(opts = {})
      @access_token = opts[:access_token]
      @logger = opts[:logger]
    end

    def alert(message)
      @logger.debug "PushBullet message: '#{message}' with access token: #{@access_token}"

      uri = URI("https://api.pushbullet.com/v2/pushes")
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      request.basic_auth(@access_token, '')
      request['Content-Type'] = 'application/json'

      request.body = {
        :type => 'note',
        :title => 'shelvesd',
        :body => message
      }.to_json

      response = https.request(request)
    end
  end
end
