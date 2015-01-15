require_relative 'displays'
require_relative 'lights'

require 'json'
require 'sinatra'

set :bind, '0.0.0.0'

#########################
@@lcd = Display::Factory.create
@@lcd.write({:line1 => 'Booting shelvesd...' })

@@light = Light::Factory.create
# initialize to on
# TODO initialize to scheduled state
@@light.on

def lcd_write_banner
  #line 1
  hostname = `hostname -s`[0..-2]

  # line 2
  weather_json = `curl -sS http://api.openweathermap.org/data/2.5/weather?id=5809844`
  weather = JSON.parse weather_json
  sunrise = Time.at(weather['sys']['sunrise']).localtime.strftime("%I:%M%p")
  sunset = Time.at(weather['sys']['sunset']).localtime.strftime("%I:%M%p")

  # line 3
  ip = `ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`[0..-2]

  # line 4
  sha1 = `git rev-list HEAD --max-count=1`

  @@lcd.write({
        :line1 => "shelvesd@#{hostname}",
        :line2 => "DAY: #{sunrise}-#{sunset}",
        :line3 => "IP :   #{ip}",
        :line4 => "GIT: #{sha1}"
  })
end

lcd_write_banner

######################
configure :production do
  set :port, 8123
end

get '/', :provides => 'html' do
  redirect '/index.html'
end

get '/api/v1/lcd/1', :provides => 'json' do
  @@lcd.read.to_json
end

get '/api/v1/lights', :provides => 'json' do
  { :on => @@light.on? }.to_json
end

patch '/api/v1/lights', :provides => 'json' do
  request.body.rewind  # in case someone already read it
  data = JSON.parse request.body.read

  if data['on'] == true then
    @@light.on
    @@lcd.write({:line3 => 'LIGHTS: on'})
  else
    @@light.off
    @@lcd.write({:line3 => 'LIGHTS: off'})
  end
  { :on => @@light.on? }.to_json
end

# temporary
get '/api/v1/lights/on', :provides => 'html' do
  @@light.on
  @@lcd.write({:line3 => 'LIGHTS: on'})
  '<html><body><font size="72pt"><a href=\'off\'>off</a><br/><a href=\'movie\'>movie mode</a></font></body></html>'
end
get '/api/v1/lights/off', :provides => 'html' do
  @@light.off
  @@lcd.write({:line3 => 'LIGHTS: off'})
  '<html><body><font size="72pt"><a href=\'on\'>on</a></font></body></html>'
end

get '/api/v1/lights/movie', :provides => 'html' do
  @@light.off
  @@lcd.disable
  '<html><body><font size="72pt"><a href=\'on\'>on</a></font></body></html>'
end

