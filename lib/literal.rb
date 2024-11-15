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
			:abs.to_proc => Integer,
			:ceil.to_proc => Integer,
			:chr.to_proc => String,
			:denominator.to_proc => Integer,
			:even?.to_proc => Types::BooleanType::Instance,
			:floor.to_proc => Integer,
			:hash.to_proc => Integer,
			:inspect.to_proc => String,
			:integer?.to_proc => true,
			:magnitude.to_proc => Integer,
			:negative?.to_proc => Types::BooleanType::Instance,
			:next.to_proc => Integer,
			:nonzero?.to_proc => Types::BooleanType::Instance,
			:numerator.to_proc => Integer,
			:odd?.to_proc => Types::BooleanType::Instance,
			:ord.to_proc => Integer,
			:positive?.to_proc => Types::BooleanType::Instance,
			:pred.to_proc => Integer,
			:round.to_proc => Integer,
			:size.to_proc => Integer,
			:succ.to_proc => Integer,
			:to_f.to_proc => Float,
			:to_i.to_proc => Integer,
			:to_int.to_proc => Integer,
			:to_r.to_proc => Rational,
			:to_s.to_proc => String,
			:to_s.to_proc => String,
			:truncate.to_proc => Integer,
			:zero?.to_proc => Types::BooleanType::Instance,
		},
		String => {
			:ascii_only?.to_proc => Types::BooleanType::Instance,
			:bytesize.to_proc => Integer,
			:capitalize.to_proc => String,
			:chomp.to_proc => String,
			:chop.to_proc => String,
			:downcase.to_proc => String,
			:dump.to_proc => String,
			:empty?.to_proc => Types::BooleanType::Instance,
			:hash.to_proc => Integer,
			:inspect.to_proc => String,
			:length.to_proc => Integer,
			:lstrip.to_proc => String,
			:ord.to_proc => Integer,
			:reverse.to_proc => String,
			:rstrip.to_proc => String,
			:scrub.to_proc => String,
			:size.to_proc => Integer,
			:strip.to_proc => String,
			:swapcase.to_proc => String,
			:to_str.to_proc => String,
			:upcase.to_proc => String,
			:valid_encoding?.to_proc => Types::BooleanType::Instance,
		},
		Array => {
			:size.to_proc => Integer,
			:length.to_proc => Integer,
			:empty?.to_proc => Types::BooleanType::Instance,
		},
	}

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
		of == type || (
			case of
			when Literal::Type, Module
				of >= type
			when Range
				of.cover?(type)
			else
				false
			end
		)
	end
end

require_relative "literal/rails" if defined?(Rails)
