# frozen_string_literal: true

class Literal::Array
	class Generic
		include Literal::Type

		def initialize(type)
			@type = type
		end

		attr_reader :type

		def new(*value)
			Literal::Array.new(value, type: @type)
		end

		alias_method :[], :new

		def ===(value)
			Literal::Array === value && Literal.subtype?(value.__type__, of: @type)
		end

		def >=(other)
			case other
			when Literal::Array::Generic
				@type >= other.type
			else
				false
			end
		end

		def inspect
			"Literal::Array(#{@type.inspect})"
		end
	end

	include Enumerable
	include Literal::Types

	def initialize(value, type:)
		Literal.check(actual: value, expected: _Array(type)) do |c|
			c.fill_receiver(receiver: self, method: "#initialize")
		end

		@__type__ = type
		@__value__ = value
	end

	def __initialize_without_check__(value, type:)
		@__type__ = type
		@__value__ = value
		self
	end

	# Used to create a new Literal::Array with the same type and collection type but a new value. The value is not checked.
	def __with__(value)
		Literal::Array.allocate.__initialize_without_check__(
			value,
			type: @__type__,
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

	def *(times)
		case times
		when String
			@__value__ * times
		else
			__with__(@__value__ * times)
		end
	end

	def +(other)
		case other
		when ::Array
			Literal.check(actual: other, expected: _Array(@__type__)) do |c|
				c.fill_receiver(receiver: self, method: "#+")
			end

			__with__(@__value__ + other)
		when Literal::Array(@__type__)
			__with__(@__value__ + other.__value__)
		when Literal::Array
			raise Literal::TypeError.new(
				context: Literal::TypeError::Context.new(
					expected: Literal::Array(@__type__),
					actual: other
				)
			)
		else
			raise ArgumentError.new("Cannot perform `+` with #{other.class.name}.")
		end
	end

	def -(other)
		case other
		when ::Array
			__with__(@__value__ - other)
		when Literal::Array
			__with__(@__value__ - other.__value__)
		else
			raise ArgumentError.new("Cannot perform `-` with #{other.class.name}.")
		end
	end

	def <<(value)
		Literal.check(actual: value, expected: @__type__) do |c|
			c.fill_receiver(receiver: self, method: "#<<")
		end

		@__value__ << value
		self
	end

	def <=>(other)
		case other
		when ::Array
			@__value__ <=> other
		when Literal::Array
			@__value__ <=> other.__value__
		else
			raise ArgumentError.new("Cannot perform `<=>` with #{other.class.name}.")
		end
	end

	def ==(other)
		Literal::Array === other && @__value__ == other.__value__
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

	def assoc(...)
		@__value__.assoc(...)
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

	def combination(...)
		@__value__.combination(...)
		self
	end

	def compact
		# @TODO if this is an array of nils, we should return an emtpy array
		__with__(@__value__)
	end

	def compact!
		# @TODO if this is an array of nils, we should set @__value__ = [] and return self
		nil
	end

	def count(...)
		@__value__.count(...)
	end

	def delete(...)
		@__value__.delete(...)
	end

	def delete_at(...)
		@__value__.delete_at(...)
	end

	def delete_if(...)
		@__value__.delete_if(...)
		self
	end

	def dig(...)
		@__value__.dig(...)
	end

	def drop(...)
		__with__(@__value__.drop(...))
	end

	def drop_while(...)
		__with__(@__value__.drop_while(...))
	end

	def each(...)
		@__value__.each(...)
	end

	def empty?
		@__value__.empty?
	end

	alias_method :eql?, :==

	def filter(...)
		__with__(@__value__.filter(...))
	end

	def filter!(...)
		@__value__.filter!(...)
		self
	end

	def flatten(...)
		__with__(@__value__.flatten(...))
	end

	def first(...)
		@__value__.first(...)
	end

	def flatten!(...)
		@__value__.flatten!(...) ? self : nil
	end

	def freeze
		@__value__.freeze
		super
	end

	def hash
		[self.class, @__value__].hash
	end

	def include?(...)
		@__value__.include?(...)
	end

	alias_method :index, :find_index

	def insert(index, *value)
		Literal.check(actual: value, expected: _Array(@__type__)) do |c|
			c.fill_receiver(receiver: self, method: "#insert")
		end

		@__value__.insert(index, *value)
		self
	end

	def inspect
		@__value__.inspect
	end

	def intersect?(other)
		case other
		when ::Array
			@__value__.intersect?(other)
		when Literal::Array
			@__value__.intersect?(other.__value__)
		else
			raise ArgumentError.new("Cannot perform `intersect?` with #{other.class.name}.")
		end
	end

	def intersection(*values)
		values.map! do |value|
			case value
			when Literal::Array
				value.__value__
			else
				value
			end
		end

		__with__(@__value__.intersection(*values))
	end

	def	join(...)
		@__value__.join(...)
	end

	def keep_if(...)
		return_value = @__value__.keep_if(...)
		case return_value
		when Array
			self
		else
			return_value
		end
	end

	def last(...)
		@__value__.last(...)
	end

	def length(...)
		@__value__.length(...)
	end

	def map(type, &block)
		my_type = @__type__
		transform_type = Literal::TRANSFORMS.dig(my_type, block)

		if transform_type && Literal.subtype?(transform_type, of: my_type)
			Literal::Array.allocate.__initialize_without_check__(
				@__value__.map(&block),
				type:,
			)
		else
			Literal::Array.new(@__value__.map(&block), type:)
		end
	end

	alias_method :collect, :map

	# TODO: we can make this faster
	def map!(&)
		new_array = map(@__type__, &)
		@__value__ = new_array.__value__
		self
	end

	alias_method :collect!, :map!

	def sum(...)
		@__value__.sum(...)
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

	def narrow(type)
		unless Literal.subtype?(type, of: @__type__)
			raise ArgumentError.new("Cannot narrow #{@__type__} to #{type}")
		end

		if __type__ != type
			@__value__.each do |item|
				Literal.check(actual: item, expected: type) do |c|
					c.fill_receiver(receiver: self, method: "#narrow")
				end
			end
		end

		Literal::Array.allocate.__initialize_without_check__(
			@__value__,
			type:,
		)
	end

	def one?(...)
		@__value__.one?(...)
	end

	def pack(...)
		@__value__.pack(...)
	end

	def pop(...)
		@__value__.pop(...)
	end

	def push(*value)
		Literal.check(actual: value, expected: _Array(@__type__)) do |c|
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

	def replace(value)
		case value
		when Array
			Literal.check(actual: value, expected: _Array(@__type__)) do |c|
				c.fill_receiver(receiver: self, method: "#replace")
			end

			@__value__.replace(value)
		when Literal::Array(@__type__)
			@__value__.replace(value.__value__)
		when Literal::Array
			raise Literal::TypeError.new(
				context: Literal::TypeError::Context.new(expected: @__type__, actual: value.__type__)
			)
		else
			raise ArgumentError.new("#replace expects Array argument")
		end

		self
	end

	def rotate!(...)
		@__value__.rotate!(...)
		self
	end

	def sample(...)
		@__value__.sample(...)
	end

	def select(...)
		__with__(@__value__.select(...))
	end

	def select!(...)
		@__value__.select!(...)
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

	alias_method :to_s, :inspect

	def uniq
		__with__(@__value__.uniq)
	end

	def uniq!(...)
		@__value__.uniq!(...) ? self : nil
	end

	def unshift(value)
		Literal.check(actual: value, expected: @__type__) do |c|
			c.fill_receiver(receiver: self, method: "#unshift")
		end

		@__value__.unshift(value)
		self
	end

	alias_method :prepend, :unshift

	def values_at(*indexes)
		unless @__type__ === nil
			max_value = length - 1
			min_value = -length

			indexes.each do |index|
				case index
				when Integer
					if index < min_value || index > max_value
						raise IndexError.new("index #{index} out of range")
					end
				when Range
					if index.begin < min_value || index.end > max_value
						raise IndexError.new("index #{index} out of range")
					end
				else
					raise ArgumentError.new("Invalid index: #{index.inspect}")
				end
			end
		end

		__with__(
			@__value__.values_at(*indexes)
		)
	end

	def |(other)
		case other
		when ::Array
			Literal.check(actual: other, expected: _Array(@__type__)) do |c|
				c.fill_receiver(receiver: self, method: "#|")
			end

			__with__(@__value__ | other)
		when Literal::Array(@__type__)
			__with__(@__value__ | other.__value__)
		when Literal::Array
			raise Literal::TypeError.new(
				context: Literal::TypeError::Context.new(
					expected: Literal::Array(@__type__),
					actual: other
				)
			)
		else
			raise ArgumentError.new("Cannot perform `|` with #{other.class.name}.")
		end
	end

	def fetch(...)
		@__value__.fetch(...)
	end
end
