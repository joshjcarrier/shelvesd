require 'json'
require 'sinatra'
require 'pi_piper'
include PiPiper

Dir[File.dirname(__FILE__) + '/shelvesd/*.rb'].each {|file| require file}

set :bind, '0.0.0.0'
pin = PiPiper::Pin.new(:pin => 17, :direction => :out)
pin.on # power on

#########################
@@lcd_lines = []

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
  lcd_write('shelvesd', 1)

  weather_json = `curl -sS http://api.openweathermap.org/data/2.5/weather?id=5809844`
  weather = JSON.parse weather_json
  sunrise = Time.at(weather['sys']['sunrise']).localtime.strftime("%H:%M%p")
  sunset = Time.at(weather['sys']['sunset']).localtime.strftime("%H:%M%p")

  lcd_write("DAY: #{sunrise}-#{sunset}", 2)

  sha1 = `git rev-list HEAD --max-count=1`
  lcd_write("GIT:#{sha1}", 4)
end

lcd_write_banner

######################
configure :production do
  set :port, 8123
end

get '/', :provides => 'html' do
  lcd_output = @@lcd_lines.join('<br/>')
  "<html><body><table><tr><td><iframe src='http://shelvy.int.joshjcarrier.com:8124' width='640px' height='480px'></iframe></td><td valign='top'>#{lcd_output}<hr/><a href=\'/settings.html\'>Settings</a></td></tr></table></body></html>"
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
