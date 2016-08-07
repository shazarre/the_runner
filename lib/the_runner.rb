require 'the_runner/command'
require 'the_runner/server'
require 'the_runner/server/config'
require 'the_runner/context'
require 'the_runner/context/config'
require 'the_runner/runner/base'
require 'the_runner/runner/ssh'

class TheRunner
  def initialize
    @contexts = {}
  end

  # TODO we don't always need the key, mostly when we want to run a single context
  def []=(key, context)
    @contexts[key] = context
  end

  # TODO make constant for 'default', it's used in multiple places
  def run(key = 'default')
    if @contexts.count == 1
      run_context(@contexts.first[1])
    else
      # TODO check if the key exists
      run_context(@contexts[key])
    end
  end

  protected
  def run_context(context)
    if context.config.parallel?
      threads = []
      context.servers.each { |server|
        threads << Thread.new {
          run_command_from_context_on_server(context, server)
        }
      }
      threads.each do |thread|
        thread.join
      end
    else
      context.servers.each do |server|
        run_command_from_context_on_server(context, server)
      end
    end
  end

  def run_command_from_context_on_server(context, server)
    context.get_runner_for(server).run(Command.new(context.command))
  end
end
