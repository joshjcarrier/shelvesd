module Display
    class Screen
        def initialize(options = {})
            @line_cache = {
                :line1 => '',
                :line2 => '',
                :line3 => '',
                :line4 => ''
            }
        end

        def disable
        end

        def read
            @line_cache
        end

        def write(values)
            @line_cache = @line_cache.merge values
        end
    end
end
