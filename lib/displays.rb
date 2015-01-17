Dir[File.dirname(__FILE__) + '/display/*.rb'].each {|file| require file}

module Display
    class Factory
        def self.create
            home_display = Display::LCD.new({
                :logger => SimpleLogger.new
            })

            home_display = Display::Screen.new({
                :display => home_display
            })

            display = Display::Virtual.new({
                :displays => [home_display]
            })

            display
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
