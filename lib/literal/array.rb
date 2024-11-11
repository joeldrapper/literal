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

	# Used to create a new Literal::Array with the same type and collection type but a new value. The value is not checked.
	def __with__(value)
		Literal::Array.allocate.__initialize_without_check__(
			value,
			type: @__type__,
			collection_type: @__collection_type__
		)
	end

	attr_reader :__type__, :__value__

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

	def <<(value)
		Literal.check(actual: value, expected: @__type__) do |c|
			c.fill_receiver(receiver: self, method: "#<<")
		end

		@__value__ << value
		self
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

	def all?(...)
		@__value__.all?(...)
	end

	def any?(...)
		@__value__.any?(...)
	end

	def at(...)
		@__value__.at(...)
	end

	def bsearch(...)
		@__value__.bsearch(...)
	end

	def clear(...)
		@__value__.clear(...)
		self
	end

	def count(...)
		@__value__.count(...)
	end

	def each(...)
		@__value__.each(...)
	end

	def empty?
		@__value__.empty?
	end

	def filter(...)
		__with__(@__value__.filter(...))
	end

	def filter!(...)
		@__value__.filter!(...)
		self
	end

	def first(...)
		@__value__.first(...)
	end

	def freeze
		@__value__.freeze
		super
	end

	def insert(index, *value)
		Literal.check(actual: value, expected: @__collection_type__) do |c|
			c.fill_receiver(receiver: self, method: "#insert")
		end

		@__value__.insert(index, *value)
		self
	end

	def last(...)
		@__value__.last(...)
	end

	def length(...)
		@__value__.length(...)
	end

	def map(type, &)
		Literal::Array.new(@__value__.map(&), type:)
	end

	def max(n = nil, &)
		if n
			__with__(@__value__.max(n, &))
		else
			@__value__.max(&)
		end
	end

	def min(n = nil, &)
		if n
			__with__(@__value__.min(n, &))
		else
			@__value__.min(&)
		end
	end

	def minmax(...)
		__with__(@__value__.minmax(...))
	end

	def one?(...)
		@__value__.one?(...)
	end

	def pop(...)
		@__value__.pop(...)
	end

	def push(*value)
		Literal.check(actual: value, expected: @__collection_type__) do |c|
			c.fill_receiver(receiver: self, method: "#push")
		end

		@__value__.push(*value)
		self
	end

	alias_method :append, :push

	def reject(...)
		__with__(@__value__.reject(...))
	end

	def reject!(...)
		@__value__.reject!(...)
		self
	end

	def sample(...)
		@__value__.sample(...)
	end

	def shift(...)
		@__value__.shift(...)
	end

	def size(...)
		@__value__.size(...)
	end

	def sort(...)
		__with__(@__value__.sort(...))
	end

	def sort!(...)
		@__value__.sort!(...)
		self
	end

	def to_a
		@__value__.dup
	end

	alias_method :to_ary, :to_a

	def unshift(value)
		Literal.check(actual: value, expected: @__type__) do |c|
			c.fill_receiver(receiver: self, method: "#unshift")
		end

		@__value__.unshift(value)
		self
	end

	alias_method :prepend, :unshift
end
