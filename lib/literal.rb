# frozen_string_literal: true

module Literal
	TYPE_CHECKS = ENV["LITERAL_TYPE_CHECKS"] != "false"

	autoload :Attributable, "literal/attributable"
	autoload :Attribute, "literal/attribute"
	autoload :Attributes, "literal/attributes"
	autoload :ConcurrentArray, "literal/concurrent_array"
	autoload :ConcurrentHash, "literal/concurrent_hash"
	autoload :Data, "literal/data"
	autoload :Enum, "literal/enum"
	autoload :Formatter, "literal/formatter"
	autoload :Singleton, "literal/singleton"
	autoload :Struct, "literal/struct"
	autoload :Structish, "literal/structish"
	autoload :Types, "literal/types"
	autoload :Visitor, "literal/visitor"
	autoload :Null, "literal/null"

	# Errors
	autoload :Error, "literal/errors/error"
	autoload :TypeError, "literal/errors/type_error"
end
