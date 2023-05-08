# frozen_string_literal: true

require_relative "lib/literal/version"

Gem::Specification.new do |spec|
	spec.name = "literal"
	spec.version = Literal::VERSION
	spec.authors = ["Joel Drapper"]
	spec.email = ["joel@drapper.me"]

	spec.summary = "Strict Attributes is a gem that allows you to define strict attributes on your models."
	spec.description = "Strict Attributes is a gem that allows you to define strict attributes on your models."
	spec.homepage = "https://github.com/joeldrapper/literal"
	spec.license = "MIT"
	spec.required_ruby_version = ">= 3.0"

	spec.metadata["homepage_uri"] = spec.homepage
	spec.metadata["source_code_uri"] = "https://github.com/joeldrapper/literal"
	spec.metadata["changelog_uri"] = "https://github.com/joeldrapper/literal/blob/master/CHANGELOG.md"
	spec.metadata["funding_uri"] = "https://github.com/sponsors/joeldrapper"

	# Specify which files should be added to the gem when it is released.
	# The `git ls-files -z` loads the files in the RubyGem that have been added into git.
	spec.files = Dir.chdir(__dir__) do
		`git ls-files -z`.split("\x0").reject do |f|
			(File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
		end
	end
	spec.bindir = "exe"
	spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]

	# Uncomment to register a new dependency of your gem
	spec.add_dependency "zeitwerk", "~> 2.6"

	# For more information and examples about making a new gem, check out our
	# guide at: https://bundler.io/guides/creating_gem.html
	spec.metadata["rubygems_mfa_required"] = "true"
end
