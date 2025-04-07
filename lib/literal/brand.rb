# frozen_string_literal: true

class Literal::Brand
	include Literal::Types

	def initialize(...)
		@type = _Constraint(...)
		@objects = ObjectSpace::WeakMap.new
	end

	def new(object)
		Literal.check(expected: @type, actual: object)
		@objects[object] = true
		object
	end

	alias_method :[], :new

	def ===(value)
		@objects.key?(value)
	end
end
