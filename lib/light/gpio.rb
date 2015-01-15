require 'pi_piper'
include PiPiper

module Light
    class GPIO
        def initialize(params)
	    pin = params[:pin] || 17
	    @pin = PiPiper::Pin.new(:pin => pin, :direction => :out)
        end

	def off
	    @pin.off
	end

        def on
            @pin.on
        end

	def on?
  	    pin.read #force read due to apparent pi_piper bug before calling on?
	    pin.on?
	end
    end
end
