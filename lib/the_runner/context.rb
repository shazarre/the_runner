require 'logger'

class TheRunner
  class Context
    attr_accessor :command, :config, :servers
    def initialize(logger = nil)
      @servers = []
      @command = ''
      @server_configs = {}
      @config = TheRunner::Context::Config.new
      @logger = Logger.new(STDOUT) if logger.nil?

      yield self if block_given?
    end
    def add_server(server)
      server = Server.new(server) unless server.is_a?(Server)
      @servers << server

      if block_given?
        config = Config.new
        yield config

        @server_configs[server] = config
      end
    end
    def add_servers(servers)
      servers.each do |server|
        if block_given?
          add_server(server) { |config|
            yield config
          }
        else
          add_server(server)
        end
      end
    end
    def get_runner_for(server)
      if has_specific_config_for?(server)
        @config.runner.new(server, @server_configs[server].runner_options, @logger)
      else
        @config.runner.new(server, @config.runner_options, @logger)
      end
    end
    def has_specific_config_for?(server)
      @server_configs.has_key?(server)
    end
  end
end
