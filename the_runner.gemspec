Gem::Specification.new do |spec|
  spec.authors = ['Leszek Stachowski']
  spec.description = %q{Library for running commands on multiple servers.}
  spec.email = 'leszek@stachowski.me'
  spec.executables = %w(the_runner)
  spec.files = %w(LICENSE.md README.md Therunnerfile the_runner.gemspec)
  spec.files += Dir.glob("bin/**/*")
  spec.files += Dir.glob("lib/**/*.rb")
  spec.homepage = 'https://github.com/shazarre/the_runner'
  spec.licenses = ['MIT']
  spec.name = 'the_runner'
  spec.require_paths = ['lib']
  spec.required_rubygems_version = '>= 1.3.6'
  spec.summary = spec.description
  spec.version = '0.1'
end
