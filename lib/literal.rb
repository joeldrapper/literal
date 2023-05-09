# frozen_string_literal: true

require_relative "literal/version"
require "zeitwerk"

module Literal
	Loader = Zeitwerk::Loader.for_gem.tap(&:setup)

	extend Literal::Types

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

	def self.Enum(type, &block)
		Enum.define(type, &block)
	end

	def self.Value(type, &block)
		Value.define(type, &block)
	end

	def self.Data(&block)
		Class.new(Data, &block)
	end

	def self.Struct(&block)
		Class.new(Struct, &block)
	end

	def self.Array(type)
		Literal::ArrayType.new(type)
	end

	module Singleton
		def self.new(...)
			Class.new(...).new
		end
	end
end
