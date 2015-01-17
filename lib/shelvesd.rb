require_relative 'displays'
require_relative 'lights'
require_relative 'rack'

@lcd = Display::Factory.create
@lcd.write({:line1 => 'Booting shelvesd...' })

@light = Light::Factory.create

Rack::Sinatra.run!({
  :lcd => @lcd, 
  :light => @light
})
