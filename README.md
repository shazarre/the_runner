# The Runner

## Disclaimer

This version is just a rough proof of concept. There is basically no error handling, no argument type checking, no docs,
no tests. I just wanted to have my own solution to run commands across multiple servers (ideally in parallel) and that's how
this project started. If you somehow come across the library and use it, don't hesitate to open bug / improvement tickets or
send me a PR.

## Overview

The Runner is a ruby library that provides a solution for running ssh commands across multiple servers. It's supposed to be
 highly extendable and configurable. It lets you also run commands in parallel.

## Installation

    gem install the_runner

## Usage

### Direct

This direct usage example you can try using `irb` or by embedding it into ruby file.

```ruby
require 'the_runner'

the_runner = TheRunner.new
the_runner['default'] = TheRunner::Context.new do |context|
    context.add_server('host.example.com')
    context.command = 'echo "Hello World!"'
end
the_runner.run('default')
```

### Therunnerfile

The Runner supports so called `Therunnerfile`. Below you can find contents of `Therunnerfile` which is part of the library for
demonstration purposes. It contains almost all possible configuration options out there.

```ruby

TheRunner.context("example-ls") do |context|
  # Adding single server
  context.add_server('host.example.com')
  # Command to run on specified server
  context.command = 'ls -al'
end

TheRunner.context("example-ls-multiple") do |context|
  context.add_server('host.example.com')
  # Adding another server, command will be executed sequentially
  context.add_server('another.example.com')
  context.command = 'ls -al'
end

TheRunner.context("example-ls-multiple-add-servers") do |context|
  # Instead of calling add_server twice, you can call add_servers once with array of servers
  context.add_servers(['host.example.com', 'another.example.com'])
  context.command = 'ls -al'
end

TheRunner.context("example-server-config") do |context|
  # Both add_servers and add_server will yield a server config if you provide a block. In this
  # case both servers will share the same config.
  context.add_servers(['host.example.com', 'another.example.com']) { |config|
    config.runner_options = {
      # Will disable key checks while connecting to server (default: false) by
      # prepending '-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
      :disable_key_checking => true,
      # Will use this username while connecting to server (default: nil, no username
      # would be used)
      :user => 'root',
      # Will enable ssh debugging by adding '-vvv' to the command
      :debug => true,
    }
  }
  context.command = 'ls -al'
end

TheRunner.context("example-mutiple-configs") do |context|
  # We specify one host with specific config
  context.add_server('host.example.com') { |config|
    config.runner_options = {
      :user => 'root',
    }
  }

  # Another host with different config
  context.add_server('another.example.com') { |config|
    config.runner_options = {
      :debug => true,
    }
  }

  # And yet another host without any config (which means: default one)
  context.add_server('yet-another.example.com')
  context.command = 'ls -al'
end

TheRunner.context("example-parallel") do |context|
  context.add_server('host.example.com') { |config|
    config.runner_options = {
      :user => 'root',
    }
  }
  context.add_server('another.example.com') { |config|
    config.runner_options = {
      :debug => true,
    }
  }
  context.add_server('yet-another.example.com')
  context.command = 'ls -al'
  # Parallel option means that the specified command will be executed in parallel
  # (in multiple threads) instead of sequentially.
  context.config.parallel = true
end

# Default context
TheRunner.context do |context|
  context.add_server('host.example.com')
  context.command = 'uptime'
end
```

And run command in following format:

    the_runner <context name>

for example:

    the_runner example-ls

inside directory containing the file to execute The Runner in "example-ls" context from the example `Therunnerfile`.

Things to remember:
* If you specify only one context, it will be by executed always by default, no matter what you specify on command line.
* If you don't specify <context name> on command line, "default" will be used if provided.
