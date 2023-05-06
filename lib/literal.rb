# frozen_string_literal: true

require_relative "literal/version"
require "zeitwerk"

module Literal
	Loader = Zeitwerk::Loader.for_gem.tap(&:setup)

	module Error; end

	class TypeError < ::TypeError
		include Error
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
end
