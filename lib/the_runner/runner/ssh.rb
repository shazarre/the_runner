require 'open3'

class TheRunner
  class Runner
    class SSH < Base
      @@default_options = {
          debug: false,
          disable_key_checking: false,
          user: nil,
      }
      def run(command)
        system_args = build_system_args(command)
        command = system_args.join(' ')
        log(sprintf('Running [%s]', command))

        Open3.popen2e(command) { |stdin, output|
          output.each_line { |line|
            log(line.chomp)
          }
        }
      end
      protected
      def user
        if @options[:user].nil?
          args << @server.hostname
        else
          args << "#{@options[:user]}@#{@server.hostname}"
        end
      end
      def build_system_args(command)
        args = []
        args << 'ssh'
        if @options[:debug]
          args << '-vvv'
        end
        if @options[:disable_key_checking]
          args << '-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
        end
        if @options[:user].nil?
          args << @server.hostname
        else
          args << "#{@options[:user]}@#{@server.hostname}"
        end
        args << command.to_s
      end
    end
  end
end