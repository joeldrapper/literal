# frozen_string_literal: true

require "zeitwerk"
require_relative "literal/version"

module Literal
	Loader = Zeitwerk::Loader.for_gem.tap do |loader|
		loader.inflector.inflect(
			"json_data_type" => "JSONDataType"
		)

		loader.collapse("#{__dir__}/literal/flags")
		loader.collapse("#{__dir__}/literal/errors")

		loader.setup
	end

	def self.Value(*args, **kwargs, &block)
		value_class = Class.new(Literal::Value)

		type = Literal::Types._Constraint(*args, **kwargs)
		value_class.define_method(:type) { type }

		if subtype?(type, Integer)
			value_class.alias_method :to_i, :value
		elsif subtype?(type, String)
			value_class.alias_method :to_s, :value
			value_class.alias_method :to_str, :value
		elsif subtype?(type, Array)
			value_class.alias_method :to_a, :value
			value_class.alias_method :to_ary, :value
		elsif subtype?(type, Hash)
			value_class.alias_method :to_h, :value
		elsif subtype?(type, Float)
			value_class.alias_method :to_f, :value
		elsif subtype?(type, Set)
			value_class.alias_method :to_set, :value
		end

		value_class.class_eval(&block) if block
		value_class.freeze
	end

	def self.Delegator(*args, **kwargs, &block)
		delegator_class = Class.new(Literal::Delegator)

		type = Literal::Types._Constraint(*args, **kwargs)
		delegator_class.define_method(:__type__) { type }

		delegator_class.class_eval(&block) if block
		delegator_class.freeze
	end

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

	def self.Brand(...)
		Literal::Brand.new(...)
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

	def self.subtype?(type, supertype)
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
