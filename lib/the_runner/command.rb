class TheRunner
  class Command
    def initialize(command)
      @command = command
    end

    def to_s
      @command
    end
  end
end