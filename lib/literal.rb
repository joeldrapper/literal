# frozen_string_literal: true

module Literal
	TYPE_CHECKS_DISABLED = ENV["LITERAL_TYPE_CHECKS"] == "false"

	autoload :Data, "literal/data"
	autoload :DataProperty, "literal/data_property"
	autoload :DataStructure, "literal/data_structure"
	autoload :Enum, "literal/enum"
	autoload :Null, "literal/null"
	autoload :Object, "literal/object"
	autoload :Properties, "literal/properties"
	autoload :Property, "literal/property"
	autoload :Struct, "literal/struct"
	autoload :Types, "literal/types"

	# Errors
	autoload :Error, "literal/errors/error"
	autoload :TypeError, "literal/errors/type_error"
	autoload :ArgumentError, "literal/errors/argument_error"

	def self.Enum(type)
		Class.new(Literal::Enum) do
			prop :value, type, :positional
		end
	end

	def self.check(actual:, expected:, &)
		raise ArgumentError.new("Cannot check type without a block") unless block_given?

		if expected.respond_to?(:check)
			expected.check(actual, &)
		elsif expected === actual
			true
		else
			raise Literal::TypeError.new(expected:, actual:, &)
		end
	end
end
