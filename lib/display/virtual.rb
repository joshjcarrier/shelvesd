module Display
  class Virtual
      def initialize(options = {})
        @display = options[:display]
        @screens = []
        @current_index = 0
      end

      def disable
        @display.disable
      end

      def next
        if @current_index >= @screens.length - 1
          @current_index = 0
        else
          @current_index += 1
        end

        display current
      end

      def previous
        if @current_index <= 0
          @current_index = [0, @screens.length - 1].max
        else
          @current_index -= 1
        end

        display current
      end

      def read
        return {} if current == nil
        current.read
      end

      def write(values = {})
        screen = Display::Screen.new
        set_values = screen.write values
        @screens.push screen

        if current == screen
          display screen
        end

        set_values
      end

      private
      def current
        @screens[@current_index]
      end

      def display(screen, values = {})
        return if screen == nil
        
        set_values = @display.write screen.read # writing to the display has a possibility of value sanitization
        screen.write set_values
        set_values
      end
  end
end