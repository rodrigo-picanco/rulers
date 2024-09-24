# frozen_string_literal: true

require_relative "lib/rulers/version"

Gem::Specification.new do |spec|
  spec.name = "rulers"
  spec.version = Rulers::VERSION
  spec.authors = ["Rodrig"]
  spec.email = ["rodrigo@fakemail.com"]

  spec.summary = "Ruby on rulers"
  spec.description = "Ruby on rulers rule"
  spec.homepage = "https://github.com/rodrigo-picanco"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "erubis"
  spec.add_dependency "multi_json"
  spec.add_dependency "rack", "~>2.2"
  spec.add_dependency "webrick"
  spec.add_dependency "sqlite3"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rack-test"
end
