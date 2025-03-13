# frozen_string_literal: true

class Literal::Types::PredicateType
	include Literal::Type

	def initialize(message:, block:)
		@message = message
		@block = block

		freeze
	end

	def inspect
		%(_Predicate("#{@message}"))
	end

	def ===(other)
		@block === other
	end

	freeze
end
