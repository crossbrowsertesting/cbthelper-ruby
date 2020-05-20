
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cbthelper/version"

Gem::Specification.new do |spec|
  spec.name          = "cbthelper"
  spec.version       = Cbthelper::VERSION
  spec.authors       = ["Daphne Magsby"]
  spec.email         = ["daphnem@crossbrowsertesting.com"]

  spec.summary       = "cbthelper"
  spec.description   = "cbthelper wraps CrossBrowserTesting's (https://crossbrowsertesting.com/apidocs/v3/selenium.html) into an easy to use library."
  spec.homepage      = "https://help.crossbrowsertesting.com/selenium-testing/getting-started/cbthelper-ruby/"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/crossbrowsertesting/cbthelper-ruby"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
