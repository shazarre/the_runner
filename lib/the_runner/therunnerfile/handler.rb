class TheRunner
  def self.context(key = 'default')
    context = TheRunner::Context.new
    yield context
    TheRunner::Therunnerfile::Handler.add_context(key, context)
  end
  class Therunnerfile
    class Handler
      @@contexts = {}
      def self.add_context(key, context)
        @@contexts[key] = context
      end
      def handle(key)
        key = 'default' if key.nil?
        the_runner = TheRunner.new
        @@contexts.each { |key, value|
          the_runner[key] = value
        }
        the_runner.run(key)
      end
    end
  end
end