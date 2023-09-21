# frozen_string_literal: true

# @abstract
class Literal::Result < Literal::Monad
	def initialize(type, value)
		@type = type
		@value = value
		freeze
	end

	attr_accessor :value

	# @return [Array]
	def deconstruct
		[@value]
	end
end
