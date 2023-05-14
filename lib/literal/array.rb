# frozen_string_literal: true

class Literal::Array
	include Enumerable

	def initialize(value, type:)
		@value = value
		@type = type
	end

	attr_reader :value, :type
	protected attr_writer :value

	def each(&block)
		@value.each(&block)
	end

	def safe_map(type = @type, &block)
		Literal::Array.new(
			@value.map(&block),
			type:
		)
	end

	def safe_map!(type = @type, &block)
		@type = type

		@value.map! do |item|
			output = block.call(item)

			if type === output
				output
			else
				raise Literal::TypeError.expected(output, to_be_a: type)
			end
		end
	end

	def <<(item)
		unless @type === item
			raise Literal::TypeError.expected(item, to_be_a: @type)
		end

		@value << item
		self
	end

	def dup
		duplicate = super
		duplicate.value = @value.dup
		duplicate
	end

	def concat(other)
		case other
		when Literal::Array(@type)
			@value.concat(other.value)
		when Literal::_Array(@type)
			@value.concat(other)
		when Literal::Array
			raise Literal::TypeError.expected(other, to_be_a: Literal::Array(@type))
		when Array
			raise Literal::TypeError.expected(other, to_be_a: Literal::_Array(@type))
		else
			raise ArgumentError
		end
	end

	def ==(other)
		case other
		when Array
			@value == other
		when Literal::Array
			@value == other.value
		else
			false
		end
	end

	def +(other)
		duplicate = dup
		duplicate.concat(other)
		duplicate
	end
end
