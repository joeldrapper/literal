# frozen_string_literal: true

class Literal::Array
	include Enumerable

	def initialize(value, type:)
		@value = value
		@type = type
	end

	attr_accessor :value
	attr_reader :type
	protected :value

	alias_method :to_a, :value
	alias_method :to_ary, :value

	def each(&)
		@value.each(&)
	end

	def safe_map(type = @type, &)
		Literal::Array(@type).new(@value.map(&))
	end

	def map(type = Literal::Null, &)
		if Literal::Null == type
			@value.map(&)
		else
			Literal::Array(@type).new(@value.map(&))
		end
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
		super.tap { |d| d.value = @value.dup }
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

	def *(other)
		case output = @value * other
		when Array
			new(output)
		when String
			output
		else
			raise ArgumentError
		end
	end

	def |(other)
		case other
		when Literal::Array
			if @type == other.type
				new(@value | other.value)
			else
				raise Literal::TypeError.expected(other, to_be_a: Literal::Array(@type))
			end
		when Array
			if Literal::_Array(@type) === other
				new(@value | other)
			else
				raise Literal::TypeError.expected(other, to_be_a: Literal::_Array(@type))
			end
		end
	end

	def &(other)
		case other
		when Literal::Array(@type)
			new(@value & other.value)
		else
			@value & other
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
		self if @value.sort!
	end

	def rotate!(...)
		self if @value.rotate!(...)
	end

	def sort_by!(...)
		self if @value.sort_by!(...)
	end

	def select!(...)
		self if @value.select!(...)
	end

	alias_method :filter!, :select!

	def reject!(...)
		self if @value.reject!(...)
	end

	def uniq!(...)
		self if @value.uniq!(...)
	end

	def compact!
		@value.compact!
		self
	end

	def shuffle(...)
		new @value.shuffle(...)
	end

	def shuffle!(...)
		self if @value.shuffle!(...)
	end

	def reverse
		new @value.reverse
	end

	def reverse!
		self if @value.reverse!
	end

	def empty?
		@value.empty?
	end

	def shift(n = nil)
		n ? new(@value.shift(n)) : @value.shift
	end

	def pop(n = nil)
		n ? new(@value.pop(n)) : @value.pop
	end

	def sample(n = nil, random: nil)
		n ? new(@value.sample(n, random:)) : @value.sample(random:)
	end

	def last(n = nil)
		n ? new(@value.last(n)) : @value.last
	end

	def first(n = nil)
		n ? new(@value.first(n)) : @value.first
	end

	def join(...)
		@value.join(...)
	end

	def pack(...)
		@value.pack(...)
	end

	def at(i)
		@value.at(i)
	end

	def fetch(...)
		@value.fetch(...)
	end

	def union(*others)
		others.map! do |other|
			case other
			when Literal::Array
				if @type == other.type
					other.value
				else
					raise Literal::TypeError.expected(other, to_be_a: Literal::Array(@type))
				end
			when Array
				if Literal::_Array(@type) === other
					other
				else
					raise Literal::TypeError.expected(other, to_be_a: Literal::_Array(@type))
				end
			else
				raise ArgumentError
			end
		end

		new(@value.union(*others))
	end

	private def new(value)
		Literal::Array.new(value, type: @type)
	end
end
