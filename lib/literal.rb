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
			:floor.to_proc => Integer,
			:hash.to_proc => Integer,
			:magnitude.to_proc => Integer,
			:next.to_proc => Integer,
			:numerator.to_proc => Integer,
			:ord.to_proc => Integer,
			:pred.to_proc => Integer,
			:round.to_proc => Integer,
			:size.to_proc => Integer,
			:succ.to_proc => Integer,
			:to_i.to_proc => Integer,
			:to_int.to_proc => Integer,
			:to_s.to_proc => String,
			:truncate.to_proc => Integer,
			:inspect.to_proc => String,
			:to_s.to_proc => String,
			:to_f.to_proc => Float,
			:even?.to_proc => Types::BooleanType::Instance,
			:integer?.to_proc => true,
			:negative?.to_proc => Types::BooleanType::Instance,
			:odd?.to_proc => Types::BooleanType::Instance,
			:positive?.to_proc => Types::BooleanType::Instance,
			:zero?.to_proc => Types::BooleanType::Instance,
			:nonzero?.to_proc => Types::BooleanType::Instance,
			:to_r.to_proc => Rational,
		},
		String => {
			:length.to_proc => Integer,
		},
		Array => {
			:size.to_proc => Integer,
			:length.to_proc => Integer,
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
			else
				false
			end
		)
	end
end

require_relative "literal/rails" if defined?(Rails)
