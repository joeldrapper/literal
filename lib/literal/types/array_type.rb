# frozen_string_literal: true

# @api private
class Literal::Types::ArrayType
	CACHE = ObjectSpace::WeakMap.new

	include Literal::Type

	def initialize(type)
		@type = type
		freeze
	end

	attr_reader :type

	def inspect
		"_Array(#{@type.inspect})"
	end

	def ===(value)
		return false unless Array === value

		if value.frozen?
			if CACHE[value]
				true
			elsif value.all?(@type)
				CACHE[value] = true
			else
				CACHE[value] = false
			end
		else
			value.all?(@type)
		end
	end

	def >=(other)
		case other
		when Literal::Types::ArrayType
			@type >= other.type
		else
			false
		end
	end

	def record_literal_type_errors(context)
		unless Array === context.actual
			return
		end

		context.actual.each_with_index do |item, index|
			unless @type === item
				context.add_child(label: "[#{index}]", expected: @type, actual: item)
			end
		end
	end

	freeze
end
