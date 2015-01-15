Dir[File.dirname(__FILE__) + '/light/*.rb'].each {|file| require file}

module Light
    class Factory
        def self.create
            light = Light::GPIO.new({
                :logger => SimpleLogger.new
            })

            light
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
