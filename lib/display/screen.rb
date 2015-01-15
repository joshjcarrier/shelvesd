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
            @line_cache
        end

        def write(values)
            @line_cache = @line_cache.merge(values){ |key, old, new| new[0, 20] }
            @display.write(values)
        end
    end
end
