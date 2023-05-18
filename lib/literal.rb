# frozen_string_literal: true

require "zeitwerk"
require "concurrent-ruby"

module Literal
	Loader = Zeitwerk::Loader.for_gem.tap do |loader|
		loader.inflector.inflect(
			"lru" => "LRU",
			"lru_type" => "LRUType"
		)
		loader.setup
	end

	extend Literal::Types

	AccessorConfiguration = _Union(:public, :protected, :private, false)

	module Error; end

	class TypeError < ::TypeError
		include Error

		def self.expected(value, to_be_a: nil, to_be_an: nil)
			type = to_be_a || to_be_an || (raise ArgumentError, "You must pass the expected type as `to_be_a:` or `to_be_an:`.")
			new("Expected `#{value.inspect}` to be of type: `#{type.inspect}`.")
		end
	end

	class ArgumentError < ::ArgumentError
		include Error
	end

	def self.Value(type, &)
		Value.define(type, &)
	end

	def self.Data(&)
		Class.new(Data, &)
	end

	def self.Struct(&)
		Class.new(Struct, &)
	end

	def self.Array(type)
		Literal::ArrayType.new(type)
	end

	module Singleton
		def self.new(...)
			Class.new(...).new
		end
	end

	def self.LRU(key_type, value_type)
		Literal::LRUType.new(key_type, value_type)
	end
end
