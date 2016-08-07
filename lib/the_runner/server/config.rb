class TheRunner
  class Server
    class Config
      attr_accessor :runner_options
      def initialize
        @runner_options = {}
      end
    end
  end
end