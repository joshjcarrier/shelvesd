require 'json'
require 'sinatra'
require 'pi_piper'
include PiPiper

Dir[File.dirname(__FILE__) + '/shelvesd/*.rb'].each {|file| require file}

set :bind, '0.0.0.0'

configure :production do
  set :port, 8123
end

get '/', :provides => 'html' do
  '<html><body><a href=\'/api/v1/lights\'>/api/v1/lights</a><br/><a href=\'/api/v1/shelves\'>/api/v1/shelves</a></body></html>'
end

get '/api/v1/lights', :provides => 'json' do

  pin = PiPiper::Pin.new(:pin => 17, :direction => :out)
  { :on => pin.on? }.to_json
end

patch '/api/v1/lights', :provides => 'json' do
  pin = PiPiper::Pin.new(:pin => 17, :direction => :out)

  request.body.rewind  # in case someone already read it
  data = JSON.parse request.body.read

  if data['on'] == true then
    pin.on
  else
    pin.off
  end
  { :on => pin.on? }.to_json
end

# temporary
get '/api/v1/lights/on', :provides => 'html' do
  pin = PiPiper::Pin.new(:pin => 17, :direction => :out)

  pin.on
  '<html><body><font size="72pt"><a href=\'off\'>off</a></font></body></html>'
end
get '/api/v1/lights/off', :provides => 'html' do
  pin = PiPiper::Pin.new(:pin => 17, :direction => :out)

  pin.off
  '<html><body><font size="72pt"><a href=\'on\'>on</a></font></body></html>'
end

get '/api/v1/shelves', :provides => 'json' do
  'Hello world!'
end
