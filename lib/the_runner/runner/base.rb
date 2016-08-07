class TheRunner
  class Runner
    class Base
      @@default_options = {}

      # TODO Not quite sure about logger injection here.
      def initialize(server, options = {}, logger = nil)
        @server, @options = server, @@default_options.merge(options)
        @logger = logger
      end
      def log(message)
        # TODO Of course there should be more levels of log than just debug.
        @logger.debug(sprintf('[%s] %s', @server.hostname, message)) unless @logger.nil?
      end
    end
  end
end
