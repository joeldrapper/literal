# frozen_string_literal: true

module Literal
	TRACING = ENV["LITERAL_TRACING"] != "false"
	TYPE_CHECKS = ENV["LITERAL_TYPE_CHECKS"] != "false"
	EXPENSIVE_TYPE_CHECKS = ENV["LITERAL_EXPENSIVE_TYPE_CHECKS"] != "false"

	autoload :Attributable, "literal/attributable"
	autoload :Attribute, "literal/attribute"
	autoload :ConcurrentArray, "literal/concurrent_array"
	autoload :ConcurrentHash, "literal/concurrent_hash"
	autoload :Data, "literal/data"
	autoload :Enum, "literal/enum"
	autoload :Formatter, "literal/formatter"
	autoload :Method, "literal/method"
	autoload :Singleton, "literal/singleton"
	autoload :Struct, "literal/struct"
	autoload :Structish, "literal/structish"
	autoload :Types, "literal/types"
	autoload :Union, "literal/union"
	autoload :Visitor, "literal/visitor"
	autoload :Null, "literal/null"

	# Errors
	autoload :TypeError, "literal/errors/type_error"
	autoload :Error, "literal/errors/error"

	extend Literal::Types
end
