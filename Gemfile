# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "quickdraw", git: "https://github.com/joeldrapper/quickdraw.git"
gem "benchmark-ips"

if RUBY_ENGINE == "ruby"
	group :development do
		gem "solargraph"
		gem "rubocop"
		gem "ruby-lsp"
		gem "simplecov"
	end
end
