require 'yaml'
require_relative 'displays'
require_relative 'lights'
require_relative 'rack'

def write_home(display)
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

  display.write({
        :line1 => "shelvesd@#{hostname}",
        :line2 => "DAY: #{sunrise}-#{sunset}",
        :line3 => "IP :   #{ip}",
        :line4 => "GIT: #{sha1}"
  })
end

def restore_screens(display)
  write_home display

  config = YAML.load_file(File.dirname(__FILE__) + "/../configuration.yml")
  config["screens"].each do |screen|
    display.write({
        :line1 => screen['line1'] || '',
        :line2 => screen['line2'] || '',
        :line3 => screen['line3'] || '',
        :line4 => screen['line4'] || ''
  })
  end
end 

display = Display::Factory.create
light = Light::Factory.create

# initialize light to on
# TODO light according to schedule
light.on

restore_screens display

Rack::Sinatra.run!({
  :display => display, 
  :light => light
})
