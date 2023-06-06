# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
	command_name "Tests"
	enable_coverage :branch
	enable_coverage_for_eval

	add_group "Types", "lib/literal/types"
end

require "literal"

Zeitwerk::Loader.eager_load_all
