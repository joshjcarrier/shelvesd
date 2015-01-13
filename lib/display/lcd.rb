module Display
    class LCD
        def initialize(opts = {})
            @logger = opts[:logger]
        end

        def disable
            cmd = "python #{lcd_exec_file} bl 0"
            @logger.debug "Executing '#{cmd}'"
            system cmd
        end

        def read
            {
                :line1 => '',
                :line2 => '',
                :line3 => '',
                :line4 => ''
            }
        end

        def write(values)
            line1 = values[:line1]
            line2 = values[:line2]
            line3 = values[:line3]
            line4 = values[:line4]

            cmd = "python #{lcd_exec_file} txt '#{line1}' '#{line2}' '#{line3}' '#{line4}'"
            @logger.debug "Executing '#{cmd}'"
            system cmd
        end

        private
        def lcd_exec_file
            "#{File.dirname(__FILE__)}/../../ext/lcd/lcd.py"
        end
    end
end
