# frozen_string_literal: true

class Literal::Value
	def initialize(value)
		type = self.class.__type__
		raise Literal::TypeError, "Expected value: `#{value.inspect}` to be: `#{type.inspect}`." unless type === value

		@value = value.frozen? ? value : value.dup.freeze
		freeze
	end

	attr_reader :value

	def inspect
		"#{self.class.name}(#{value.inspect})"
	end

	class StringValue < Literal::Value
		alias_method :to_s, :value
		alias_method :to_str, :value
	end

	class SymbolValue < Literal::Value
		alias_method :to_sym, :value
	end

	class IntegerValue < Literal::Value
		alias_method :to_i, :value
	end

	class FloatValue < Literal::Value
		alias_method :to_f, :value
	end

	class SetValue < Literal::Value
		alias_method :to_set, :value
	end

	class ArrayValue < Literal::Value
		alias_method :to_a, :value
		alias_method :to_ary, :value
	end

	class HashValue < Literal::Value
		alias_method :to_h, :value
	end

	class ProcValue < Literal::Value
		alias_method :to_proc, :value
	end

	TYPE_CLASSES = {
		String => StringValue,
		Symbol => SymbolValue,
		Integer => IntegerValue,
		Float => FloatValue,
		Set => SetValue,
		Array => ArrayValue,
		Hash => HashValue,
		Proc => ProcValue
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
