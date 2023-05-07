# frozen_string_literal: true

class Literal::Either
	def initialize(value)
		@value = value
		freeze
	end

	attr_reader :value
	attr_accessor :type
end
