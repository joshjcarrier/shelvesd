module Light
    class Factory
        def self.create
            begin
                require File.dirname(__FILE__) + '/light/gpio.rb'
                light = Light::GPIO.new({
                    :logger => SimpleLogger.new
                })
            rescue LoadError
                light = Light::FakeLight.new({
                    :logger => SimpleLogger.new
                })
            end            

            light
        end
    end

    class FakeLight
        def initialize(params)
            @logger = params[:logger]
            @on = false
        end
        
        def off
            @logger.debug 'Light: off'
            @on = false
        end

        def on
            @logger.debug 'Light: on'
            @on = true
        end

        def on?
            @on
        end
    end

    class SimpleLogger
        def debug(msg)
            write('DEBUG', msg)
        end

        private
        def write(severity, msg)
            puts severity + ' ' + msg
        end
    end
end
