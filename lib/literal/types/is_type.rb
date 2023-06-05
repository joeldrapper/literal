# frozen_string_literal: true

class Literal::Types::IsType < Literal::Type
	def initialize(*predicates)
		@predicates = predicates
	end

	def inspect = "_Is(#{predicates.map(&:inspect).join(', ')})"

	def ===(value)
		@predicates.all? { |predicate| value.send(predicate) }
	end
end
