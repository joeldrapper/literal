# frozen_string_literal: true

class Literal::Brand
	def initialize(...)
		@type = Literal::Types._Constraint(...)
		@objects = ObjectSpace::WeakMap.new
	end

	def new(object)
		@objects[object] = true
		object
	end

	alias_method :[], :new

	def ===(value)
		@objects.key?(value)
	end
end
