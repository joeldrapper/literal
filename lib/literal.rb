# frozen_string_literal: true

module Literal
	TYPE_CHECKS_DISABLED = ENV["LITERAL_TYPE_CHECKS"] == "false"

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

	# Errors
	autoload :Error, "literal/errors/error"
	autoload :TypeError, "literal/errors/type_error"
	autoload :ArgumentError, "literal/errors/argument_error"

	TRANSFORMS = {
		Integer => {
			abs: Integer,
			ceil: Integer,
			chr: String,
			denominator: Integer,
			even?: Types::BooleanType::Instance,
			floor: Integer,
			hash: Integer,
			inspect: String,
			integer?: true,
			magnitude: Integer,
			negative?: Types::BooleanType::Instance,
			next: Integer,
			nonzero?: Types::BooleanType::Instance,
			numerator: Integer,
			odd?: Types::BooleanType::Instance,
			ord: Integer,
			positive?: Types::BooleanType::Instance,
			pred: Integer,
			round: Integer,
			size: Integer,
			succ: Integer,
			to_f: Float,
			to_i: Integer,
			to_int: Integer,
			to_r: Rational,
			to_s: String,
			truncate: Integer,
			zero?: Types::BooleanType::Instance,
		},
		String => {
			ascii_only?: Types::BooleanType::Instance,
			bytesize: Integer,
			capitalize: String,
			chomp: String,
			chop: String,
			downcase: String,
			dump: String,
			empty?: Types::BooleanType::Instance,
			hash: Integer,
			inspect: String,
			length: Integer,
			lstrip: String,
			ord: Integer,
			reverse: String,
			rstrip: String,
			scrub: String,
			size: Integer,
			strip: String,
			swapcase: String,
			to_str: String,
			upcase: String,
			valid_encoding?: Types::BooleanType::Instance,
		},
		Array => {
			size: Integer,
			length: Integer,
			empty?: Types::BooleanType::Instance,
			sort: Array,
			to_a: Array,
			to_ary: Array,
		},
	}.transform_values! { |it| it.transform_keys(&:to_proc) }.freeze

	def self.Enum(type)
		Class.new(Literal::Enum) do
			prop :value, type, :positional
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
		(of == type) || case of
		when Literal::Type, Module
			of >= type
		when Range
			of.cover?(type)
		else
			false
		end
	end
end

require_relative "literal/rails" if defined?(Rails)
