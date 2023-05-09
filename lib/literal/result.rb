# frozen_string_literal: true

class Literal::Result
	def initialize(value)
		@value = value
		freeze
	end

	# @yieldparam switch [Literal::Switch]
	def handle(&block)
		Literal::Switch.new(Literal::Success, Literal::Failure, &block).call(self, @value)
	end

	# @!method success?
	# 	@return [Boolean]

	# @!method failure?
	# 	@return [Boolean]

	# @!method success
	# 	@return [Literal::Maybe]

	# @!method failure
	# 	@return [Literal::Maybe]

	# @!method map

	# @!method bind

	# @!method maybe
	# 	@return [Literal::Result]

	# @!method filter
	# 	@return [Literal::Result]
end
