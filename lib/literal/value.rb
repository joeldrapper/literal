# frozen_string_literal: true

class Literal::Value
	def initialize(value)
		unless __type__ === value
			raise Literal::TypeError.expected(value, to_be_a: __type__)
		end

		@value = value.frozen? ? value : value.dup.freeze

		freeze
	end

	attr_reader :value

	def inspect = "#{self.class.name}(#{value.inspect})"

	private

	def __type__ = self.class.__type__

	TYPE_CLASSES = {
		Set => SetValue,
		Proc => ProcValue,
		Hash => HashValue,
		Array => ArrayValue,
		Float => FloatValue,
		String => StringValue,
		Symbol => SymbolValue,
		Integer => IntegerValue,
	}

	class << self
		attr_reader :__type__

		def define(type, &block)
			type_class = Class.new(TYPE_CLASSES[type] || self, &block)
			type_class.instance_variable_set(:@__type__, type)
			type_class
		end
	end
end
