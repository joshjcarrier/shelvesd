Dir[File.dirname(__FILE__) + '/display/*.rb'].each {|file| require file}

module Display
    class Factory
        def self.create
            lcd_display = Display::LCD.new({
                :logger => SimpleLogger.new    
            })

            display = Display::Virtual.new({
                :display => lcd_display    
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
