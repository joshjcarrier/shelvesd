require 'json'
require 'sinatra'
require 'pi_piper'
include PiPiper

Dir[File.dirname(__FILE__) + '/shelvesd/*.rb'].each {|file| require file}

set :bind, '0.0.0.0'
pin = PiPiper::Pin.new(:pin => 17, :direction => :out)
pin.on # power on

#########################
@@lcd_lines = ['', '', '', '']

def lcd_write(str, linenum)
  @@lcd_lines[linenum-1] = str

  cmd = "python #{File.dirname(__FILE__)}/../ext/lcd/lcd.py txt '#{@@lcd_lines[0]}' '#{@@lcd_lines[1]}' '#{@@lcd_lines[2]}' '#{@@lcd_lines[3]}'"
  system cmd
end

def lcd_backlight_off
  cmd = "python #{File.dirname(__FILE__)}/../ext/lcd/lcd.py bl 0"
  system cmd
end

def lcd_write_banner
  hostname = `hostname -s`[0..-2]
  lcd_write("shelvesd@#{hostname}", 1)

  weather_json = `curl -sS http://api.openweathermap.org/data/2.5/weather?id=5809844`
  weather = JSON.parse weather_json
  sunrise = Time.at(weather['sys']['sunrise']).localtime.strftime("%I:%M%p")
  sunset = Time.at(weather['sys']['sunset']).localtime.strftime("%I:%M%p")

  lcd_write("DAY: #{sunrise}-#{sunset}", 2)

  ip = `ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`[0..-2]
  lcd_write("IP :   #{ip}", 3)

  sha1 = `git rev-list HEAD --max-count=1`
  lcd_write("GIT: #{sha1}", 4)
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
  { 
    :line1 => @@lcd_lines[0][0,20],
    :line2 => @@lcd_lines[1][0,20],
    :line3 => @@lcd_lines[2][0,20],
    :line4 => @@lcd_lines[3][0,20]
  }.to_json
end

get '/api/v1/lights', :provides => 'json' do

  pin.read #force read due to pi_piper bug before calling on?
  { :on => pin.on? }.to_json
end

patch '/api/v1/lights', :provides => 'json' do
  request.body.rewind  # in case someone already read it
  data = JSON.parse request.body.read

  if data['on'] == true then
    pin.on
    lcd_write('LIGHTS: on', 3)
  else
    pin.off
    lcd_write('LIGHTS: off', 3)
  end
  pin.read #force read due to pi_piper bug before calling on?
  { :on => pin.on? }.to_json
end

# temporary
get '/api/v1/lights/on', :provides => 'html' do
  pin.on
  lcd_write('LIGHTS: on', 3)
  '<html><body><font size="72pt"><a href=\'off\'>off</a><br/><a href=\'movie\'>movie mode</a></font></body></html>'
end
get '/api/v1/lights/off', :provides => 'html' do
  pin.off
  lcd_write('LIGHTS: off', 3)
  '<html><body><font size="72pt"><a href=\'on\'>on</a></font></body></html>'
end

get '/api/v1/lights/movie', :provides => 'html' do
  pin.off
  lcd_backlight_off
  '<html><body><font size="72pt"><a href=\'on\'>on</a></font></body></html>'
end

get '/api/v1/shelves', :provides => 'json' do
  'Hello world!'
end
