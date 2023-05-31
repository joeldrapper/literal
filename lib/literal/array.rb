# frozen_string_literal: true

class Literal::Array
	include Enumerable

	def initialize(value, type:)
		@value = value
		@type = type
	end

	attr_reader :value, :type
	protected attr_writer :value

	alias_method :to_a, :value
	alias_method :to_ary, :value

	def each(&)
		@value.each(&)
	end

	def safe_map(type = @type, &)
		Literal::Array(@type).new(@value.map(&))
	end

	def map!(type = @type, &block)
		@value.map! do |item|
			output = block.call(item)

			if type === output
				output
			else
				raise Literal::TypeError.expected(output, to_be_a: type)
			end
		end

		@type = type
	end

	def <<(item)
		unless @type === item
			raise Literal::TypeError.expected(item, to_be_a: @type)
		end

		@value << item
		self
	end

	def []=(index, item)
		unless @type === item
			raise Literal::TypeError.expected(item, to_be_a: @type)
		end

		@value[index] = item
	end

	def [](index)
		@value[index]
	end

	def prepend(*elements)
		case elements
		when Literal::_Array(@type)
			@value.prepend(*elements)
		else
			raise Literal::TypeError.expected(elements, to_be_a: Literal::_Array(@type))
		end
	end

	alias_method :unshift, :prepend

	def append(*elements)
		case elements
		when Literal::_Array(@type)
			@value.append(*elements)
		else
			raise Literal::TypeError.expected(elements, to_be_a: Literal::_Array(@type))
		end
	end

	alias_method :push, :append

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

	def -(other)
		case other
		when Array
			Literal::Array.new(@value - other, type: @type)
		when Literal::Array
			Literal::Array.new(@value - other.value, type: @type)
		else
			raise ArgumentError
		end
	end

	def clear
		@value.clear
		self
	end

	def length
		@value.length
	end

	def size
		@value.size
	end

	def delete(...)
		@value.delete(...)
	end

	def sort!
		@value.sort!
		self
	end

	def rotate!(...)
		@value.rotate!(...)
		self
	end

	def sort_by!(...)
		@value.sort_by!(...)
		self
	end

	def select!(...)
		self if @value.select!(...)
	end

	alias_method :filter!, :select!

	def reject!(...)
		self if @value.reject!(...)
	end

	def uniq!(...)
		@value.uniq!(...)
		self
	end

	def compact!
		@value.compact!
		self
	end

	def shuffle(...)
		Literal::Array(@type).new(
			@value.shuffle(...)
		)
	end

	def shuffle!(...)
		@value.shuffle!(...)
		self
	end

	def reverse
		Literal::Array(@type).new(@value.reverse)
	end

	def reverse!
		@value.reverse!
		self
	end

	def empty?
		@value.empty?
	end

	def shift(n = nil)
		if n
			Literal::Array(@type).new(@value.shift(n))
		else
			@value.shift
		end
	end

	def pop(n = nil)
		if n
			Literal::Array(@type).new(@value.pop(n))
		else
			@value.pop
		end
	end

	def sample(n = nil, random: nil)
		if n
			Literal::Array(@type).new(@value.sample(n, random:))
		else
			@value.sample(random:)
		end
	end
end
