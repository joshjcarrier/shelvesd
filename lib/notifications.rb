Dir[File.dirname(__FILE__) + '/notification/*.rb'].each {|file| require file}

module Notification
    class Factory
        def self.create(opts = {})
            notifier = Notification::PushBullet.new({
              :access_token => opts[:pushbullet_access_token],  
              :logger => SimpleLogger.new
            })

            notifier
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
