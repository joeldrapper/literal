# frozen_string_literal: true

class Literal::ArrayGeneric
	def initialize(type)
		@type = type
	end

	def new(*value)
		Literal::Array.new(@type, value)
	end

	alias_method :[], :new

	def ===(value)
		Literal::Array === value && @type == value.__type__
	end
end

class Literal::Array
	def initialize(type, value)
		unless Array === value && value.all?(type)
			raise
		end

		@__type__ = type
		@__value__ = value
	end

	attr_reader :__type__

	def each(...)
		@__value__.each(...)
	end

	def map(type, &)
		Literal::Array.new(type, @__value__.map(&))
	end

	def [](index)
		@__value__[index]
	end

	def <<(value)
		unless @__type__ === value
			raise
		end

		@__value__ << value
		self
	end
end
