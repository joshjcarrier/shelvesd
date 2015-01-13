module Display
    class Screen
        def initialize(params)
            @display = params[:display]

            @line_cache = {
                :line1 => '',
                :line2 => '',
                :line3 => '',
                :line4 => ''
            }
        end

        def disable
            @display.disable
        end

        def read
            @display.read
        end

        def write(values)
            @line_cache = @line_cache.merge values
            @display.write(values)
        end
    end
end
