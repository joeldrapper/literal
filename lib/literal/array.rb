# frozen_string_literal: true

class Literal::Array
	class Generic
		def initialize(type)
			@type = type
		end

		def new(*value)
			Literal::Array.new(value, type: @type)
		end

		alias_method :[], :new

		def ===(value)
			Literal::Array === value && @type == value.__type__
		end

		def inspect
			"Literal::Array(#{@type.inspect})"
		end
	end

	include Enumerable

	def initialize(value, type:)
		collection_type = Literal::Types::ArrayType.new(type)

		Literal.check(actual: value, expected: collection_type) do |c|
			c.fill_receiver(receiver: self, method: "#initialize")
		end

		@__type__ = type
		@__value__ = value
		@__collection_type__ = collection_type
	end

	def __initialize_without_check__(value, type:, collection_type:)
		@__type__ = type
		@__value__ = value
		@__collection_type__ = type
		self
	end

	def __with__(value)
		Literal::Array.allocate.__initialize_without_check__(
			value,
			type: @__type__,
			collection_type: @__collection_type__
		)
	end

	attr_reader :__type__, :__value__

	def freeze
		@__value__.freeze
		super
	end

	def each(...)
		@__value__.each(...)
	end

	def map(type, &)
		Literal::Array.new(@__value__.map(&), type:)
	end

	def [](index)
		@__value__[index]
	end

	def []=(index, value)
		Literal.check(actual: value, expected: @__type__) do |c|
			c.fill_receiver(receiver: self, method: "#[]=")
		end

		@__value__[index] = value
	end

	def <<(value)
		Literal.check(actual: value, expected: @__type__) do |c|
			c.fill_receiver(receiver: self, method: "#<<")
		end

		@__value__ << value
		self
	end

	def &(other)
		case other
		when ::Array
			__with__(@__value__ & other)
		when Literal::Array
			__with__(@__value__ & other.__value__)
		else
			raise ArgumentError.new("Cannot perform bitwise AND with #{other.class.name}.")
		end
	end

	def push(value)
		Literal.check(actual: value, expected: @__type__) do |c|
			c.fill_receiver(receiver: self, method: "#push")
		end

		@__value__.push(value)
		self
	end

	def unshift(value)
		Literal.check(actual: value, expected: @__type__) do |c|
			c.fill_receiver(receiver: self, method: "#unshift")
		end

		@__value__.unshift(value)
		self
	end

	def to_a
		@__value__.dup
	end

	alias_method :to_ary, :to_a

	def sort(...)
		__with__(@__value__.sort(...))
	end

	def any?(...) = @__value__.any?(...)
	def all?(...) = @__value__.all?(...)
	def sample(...) = @__value__.sample(...)
	def sort!(...) = @__value__.sort!(...)
	def pop(...) = @__value__.pop(...)
	def shift(...) = @__value__.shift(...)
end
