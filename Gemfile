# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "quickdraw", git: "https://github.com/joeldrapper/quickdraw.git"

if RUBY_ENGINE == "ruby"
	group :development do
		gem "solargraph"
		gem "rubocop"
		gem "ruby-lsp"
		gem "simplecov"
		gem "thor"
		gem "git"

		# Profiling etc
		gem "benchmark-ips"
		gem "memory_profiler"
		gem "singed"
		gem "stackprof"


		# To compare to:
		gem "dry-initializer"
		gem "dry-types"
		gem "dry-struct"
		gem "ruby-enum"
		gem "typesafe_enum"
	end
end
