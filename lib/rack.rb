require 'json'
require 'sinatra/base'

module Rack
  class Sinatra < Sinatra::Base

    def initialize(app = nil)
      super app
      @display = settings.display
      @light = settings.light
    end

    def self.run!(options)
      configure do
        set :display => options[:display]
        set :light => options[:light]
        set :bind, '0.0.0.0'
      end

      configure :production do
        set :port, 8123
      end

      super
    end

    get '/', :provides => 'html' do
      redirect '/index.html'
    end

    get '/api/v1/lcd/1', :provides => 'json' do
      @display.read.to_json
    end

    post '/api/v1/system/upgrade', :provides => 'json' do
      cmd = "cd #{IO::File.dirname(__FILE__)}/../ && git fetch && git reset --hard origin && make install && reboot"
      system cmd
      return {:message => 'OK'}.to_json
    end

    get '/api/v1/lights', :provides => 'json' do
      { :on => @light.on? }.to_json
    end

    patch '/api/v1/lights', :provides => 'json' do
      request.body.rewind  # in case someone already read it
      data = JSON.parse request.body.read

      if data['on'] == true then
        @light.on
      else
        @light.off
      end
      { :on => @light.on? }.to_json
    end

    # temporary
    get '/api/v1/lights/on', :provides => 'html' do
      @light.on
      '<html><body><font size="72pt"><a href=\'off\'>off</a><br/><a href=\'movie\'>movie mode</a></font></body></html>'
    end
    get '/api/v1/lights/off', :provides => 'html' do
      @light.off
      '<html><body><font size="72pt"><a href=\'on\'>on</a></font></body></html>'
    end

    get '/api/v1/lights/movie', :provides => 'html' do
      @light.off
      @display.disable
      '<html><body><font size="72pt"><a href=\'on\'>on</a></font></body></html>'
    end
  end
end
