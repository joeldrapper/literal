# frozen_string_literal: true

class Literal::Brand
	extend Literal::Types
	include Literal::Types

	# These types are alwys interned so branding doesn’t make sense.
	Interned = _Union(
		Integer,
		Symbol,
		_Boolean,
		nil
	)

	def initialize(...)
		@type = _Constraint(...)

		if Literal.subtype?(@type, of: Interned)
			raise ArgumentError.new("You can’t brand an interned object. Use a Literal::Value instead.")
		end

		@objects = ObjectSpace::WeakMap.new
	end

	def new(object)
		Literal.check(expected: @type, actual: object)

		dup = object.frozen? ? object.dup.freeze : object.dup
		@objects[dup] = true
		dup
	end

	alias_method :[], :new

	def ===(value)
		@objects.key?(value)
	end
end
