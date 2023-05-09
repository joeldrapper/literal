# frozen_string_literal: true

class Literal::Types::IsType
	def initialize(*predicates)
		@predicates = predicates
	end

	def inspect
		"_Is(#{predicates.map(&:inspect).join(', ')})"
	end

	def ===(value)
		@predicates.all? { |predicate| value.send(predicate) }
	end
end
