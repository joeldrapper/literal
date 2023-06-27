# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
	command_name "Tests"
	enable_coverage :branch
	enable_coverage_for_eval

	add_group "Types", "lib/literal/types"
end

module ToChange
	def to_change(from:, to:)
		original = block.call
		yield
		changed = block.call

		assert(from === original) { "Expected `#{original.inspect}` to == `#{from.inspect}`." }
		assert(to === changed) { "Expected `#{changed.inspect}` to == `#{to.inspect}`." }
	end
end

require "literal"

Zeitwerk::Loader.eager_load_all

class ExampleStruct < Literal::Struct
	attribute :name, String
end
