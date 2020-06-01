
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "furikake/version"

Gem::Specification.new do |spec|
  spec.name          = "furikake"
  spec.version       = Furikake::VERSION
  spec.authors       = ["inokappa"]
  spec.email         = ["inokara@gmail.com"]

  spec.summary       = %q{It is a command line tool to register your resources in Wiki page (Markdown format).}
  spec.description   = %q{It is a command line tool to register your resources in Wiki page (Markdown format).}
  spec.homepage      = "https://github.com/inokappa/furikake"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "octorelease"

  spec.add_dependency 'thor'
  spec.add_dependency 'aws-sdk'
  spec.add_dependency 'markdown-tables'
  spec.add_dependency 'backlog_kit'
end
