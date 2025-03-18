# frozen_string_literal: true

module Literal
	autoload :Array, "literal/array"
	autoload :Data, "literal/data"
	autoload :DataProperty, "literal/data_property"
	autoload :DataStructure, "literal/data_structure"
	autoload :Enum, "literal/enum"
	autoload :Flags, "literal/flags"
	autoload :Flags16, "literal/flags"
	autoload :Flags32, "literal/flags"
	autoload :Flags64, "literal/flags"
	autoload :Flags8, "literal/flags"
	autoload :Hash, "literal/hash"
	autoload :Null, "literal/null"
	autoload :Object, "literal/object"
	autoload :Properties, "literal/properties"
	autoload :Property, "literal/property"
	autoload :Set, "literal/set"
	autoload :Struct, "literal/struct"
	autoload :Type, "literal/type"
	autoload :Types, "literal/types"
	autoload :Tuple, "literal/tuple"

	autoload :Value, "literal/value"

	def self.Value(*, **, &block)
		value_class = Class.new(Literal::Value)

		type = Literal::Types._Constraint(*, **)
		value_class.define_method(:type) { type }

		if subtype?(type, of: Integer)
			value_class.alias_method :to_i, :value
		elsif subtype?(type, of: String)
			value_class.alias_method :to_s, :value
			value_class.alias_method :to_str, :value
		elsif subtype?(type, of: Array)
			value_class.alias_method :to_a, :value
			value_class.alias_method :to_ary, :value
		elsif subtype?(type, of: Hash)
			value_class.alias_method :to_h, :value
		elsif subtype?(type, of: Float)
			value_class.alias_method :to_f, :value
		elsif subtype?(type, of: Set)
			value_class.alias_method :to_set, :value
		end

		value_class.class_eval(&block) if block
		value_class.freeze
	end

	# Errors
	autoload :Error, "literal/errors/error"
	autoload :TypeError, "literal/errors/type_error"
	autoload :ArgumentError, "literal/errors/argument_error"

	autoload :TRANSFORMS, "literal/transforms"

	def self.Enum(type)
		Class.new(Literal::Enum) do
			prop :value, type, :positional, reader: :public
		end
	end

	def self.Array(type)
		Literal::Array::Generic.new(type)
	end

	def self.Set(type)
		Literal::Set::Generic.new(type)
	end

	def self.Hash(key_type, value_type)
		Literal::Hash::Generic.new(key_type, value_type)
	end

	def self.Tuple(*types)
		Literal::Tuple::Generic.new(*types)
	end

	def self.check(actual:, expected:)
		if expected === actual
			true
		else
			context = Literal::TypeError::Context.new(expected:, actual:)
			expected.record_literal_type_errors(context) if expected.respond_to?(:record_literal_type_errors)
			yield context if block_given?
			raise Literal::TypeError.new(context:)
		end
	end

	def self.subtype?(type, of:)
		supertype = of
		subtype = type

		subtype = subtype.block.call if Types::DeferredType === subtype

		return true if supertype == subtype

		case supertype
		when Literal::Type
			supertype >= subtype
		when Module
			case subtype
			when Module
				supertype >= subtype
			when Numeric
				Numeric >= supertype
			when String
				String >= supertype
			when Symbol
				Symbol >= supertype
			when ::Array
				::Array >= supertype
			when ::Hash
				::Hash >= supertype
			else
				false
			end
		when Range
			supertype.cover?(subtype)
		else
			false
		end
	end
end

require_relative "literal/rails" if defined?(Rails)
