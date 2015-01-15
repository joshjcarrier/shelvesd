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
		# no values can be read           
 	    }
        end

        def write(values)
            line1 = values[:line1][0, 20]
            line2 = values[:line2][0, 20]
            line3 = values[:line3][0, 20]
            line4 = values[:line4][0, 20]

            cmd = "python #{lcd_exec_file} txt '#{line1}' '#{line2}' '#{line3}' '#{line4}'"
            @logger.debug "Executing '#{cmd}'"
            system cmd

	    {
	        :line1 => line1,
		:line2 => line2,
		:line3 => line3,
		:line4 => line4
	    }
        end

        private
        def lcd_exec_file
            "#{File.dirname(__FILE__)}/../../ext/lcd/lcd.py"
        end
    end
end
