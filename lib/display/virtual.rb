module Display
  class Virtual
      def initialize(params)
        @displays = params[:displays] || []
        @current_index = 0
      end

      def disable
        @displays[@current_index].disable
      end

      def next
        if @displays.length == 1
          return
        end
        
        if @current_index == @displays.length
          @current_index = 0
        else
          @current_index += 1
        end

        write
      end

      def previous
        if @displays.length == 1
          return
        end

        if @current_index == 0
          @current_index = @displays.length - 1
        else
          @current_index -= 1
        end

        write
      end

      def read
        @displays[@current_index].read
      end

      def write(values = {})
        @displays[@current_index].write values
      end
  end
end