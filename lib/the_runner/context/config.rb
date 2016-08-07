class TheRunner
  class Context
    # TODO Not quite sure about that inheritance
    class Config < TheRunner::Server::Config
      attr_accessor :parallel
      attr_reader :runner
      def initialize
        super
        @parallel = false
        @runner = TheRunner::Runner::SSH
      end
      def runner=(runner)
        # TODO Check if class exists or if it's already a the_runner
        @runner = runner
      end
      def parallel?
        @parallel
      end
    end
  end
end
