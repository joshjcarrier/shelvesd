require 'yaml'
require_relative 'displays'
require_relative 'lights'
require_relative 'rack'

class ShelvesApp
  def initialize
    @display = Display::Factory.create
    @light = Light::Factory.create

    @config = YAML.load_file(File.dirname(__FILE__) + "/../configuration.yml")    
  end

  def run!
    restore_screens @display

    light_schedule_thread = Thread.new do
      while true do
        now_time = Time.now
        light_start_time = Time.new(now_time.year, now_time.month, now_time.day, @config['schedule']['light']['start_hour'], @config['schedule']['light']['start_min'])
        light_end_time = Time.new(now_time.year, now_time.month, now_time.day, @config['schedule']['light']['end_hour'], @config['schedule']['light']['end_min'])

        if light_start_time <= now_time && now_time <= light_end_time 
          @light.on
        else
          @light.off
        end

        sleep 60
      end
    end

    display_page_sec = @config['schedule']['display']['page_sec']
    display_pager_thread = Thread.new do
      sleep display_page_sec # initial startup delay
      while true do
        sleep display_page_sec
        @display.next
      end
    end

    Rack::Sinatra.run!({
      :display => @display, 
      :light => @light
    })
  end

  private
  def write_home(display)
    #line 1
    hostname = `hostname -s`[0..-2]

    # line 2
    light_start = Time.parse("#{@config['schedule']['light']['start_hour']}:#{@config['schedule']['light']['start_min']}").strftime("%I:%M%p")
    light_end = Time.parse("#{@config['schedule']['light']['end_hour']}:#{@config['schedule']['light']['end_min']}").strftime("%I:%M%p")

    # line 3
    weather_json = `curl -sS http://api.openweathermap.org/data/2.5/weather?id=5809844`
    weather = JSON.parse weather_json
    sunrise = Time.at(weather['sys']['sunrise']).localtime.strftime("%I:%M%p")
    sunset = Time.at(weather['sys']['sunset']).localtime.strftime("%I:%M%p")

    # line 4
    sha1 = `git rev-list HEAD --max-count=1`

    display.write({
          :line1 => "shelvesd@#{hostname}",
          :line2 => "DAY: #{light_start}-#{light_end}",
          :line3 => "SUN: #{sunrise}-#{sunset}",
          :line4 => "GIT: #{sha1}"
    })
  end

  def restore_screens(display)
    write_home display

    @config['seedlings'].each_slice(2) do |group|
      display.write({
          :line1 => if group[0] != nil then group[0]['name'] else '' end,
          :line2 => if group[0] != nil then '%20s' % "#{group[0]['germinate_min_days']} days to sprout" else '' end,
          :line3 => if group[1] != nil then group[1]['name'] else '' end,
          :line4 => if group[1] != nil then '%20s' % "#{group[1]['germinate_min_days']} days to sprout" else '' end
      })
    end
  end 
end

ShelvesApp.new.run!