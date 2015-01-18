module Display
  class Virtual
      def initialize(options = {})
        @display = options[:display]
        @screens = []
        @current_index = 0
      end

      def add_screen
        screen = Display::Screen.new
        @screens.push screen
        screen
      end

      def disable
        current.disable
      end

      def next
        if @screens.length == 1
          return
        end

        if @current_index == @screens.length
          @current_index = 0
        else
          @current_index += 1
        end

        write
      end

      def previous
        if @screens.length == 1
          return
        end

        if @current_index == 0
          @current_index = @screens.length - 1
        else
          @current_index -= 1
        end

        write
      end

      def read
        current.read
      end

      def write(values = {})
        current.write values
        set_values = @display.write current.read # writing to the display has a possibility of value sanitization
        current.write set_values
        set_values
      end

      private
      def current
        if @screens.length == 0
          add_screen
        end

        @screens[@current_index]
      end
  end
end