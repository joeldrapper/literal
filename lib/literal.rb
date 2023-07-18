# frozen_string_literal: true

require "zeitwerk"
require "concurrent-ruby"

module Literal
	TRACING = ENV["LITERAL_TRACING"] != "false"
	TYPE_CHECKS = ENV["LITERAL_TYPE_CHECKS"] != "false"
	EXPENSIVE_TYPE_CHECKS = ENV["LITERAL_EXPENSIVE_TYPE_CHECKS"] != "false"

	Loader = Zeitwerk::Loader.for_gem.tap do |loader|
		loader.inflector.inflect(
			"lru" => "LRU",
			"lru_type" => "LRUType",
			"json_data_type" => "JSONDataType"
		)
		loader.setup
	end

	extend Literal::Types

	AccessorConfiguration = _Union(:public, :protected, :private, false)

	module Error; end

	class TypeError < ::TypeError
		include Error

		def self.expected(value, to_be_a:)
			type = to_be_a
			new("Expected `#{value.inspect}` to be of type: `#{type.inspect}`.")
		end
	end

	class ArgumentError < ::ArgumentError
		include Error
	end

	# @return [Literal::Array]
	def self.Array(type)
		Literal::ArrayType.new(type)
	end

	# @return [Literal::LRU]
	def self.LRU(key_type, value_type)
		Literal::LRUType.new(key_type, value_type)
	end

	# @return [Literal::Variant]
	def self.Variant(*types)
		if block_given?
			Literal::Variant.new(yield, *types)
		else
			Literal::VariantType.new(*types)
		end
	end

	def self.Delegator(object_type)
		Class.new(Literal::Delegator) do
			attribute :__object__, object_type, positional: true, reader: :public, writer: :private
		end
	end
end
