# frozen_string_literal: true

class Literal::Failure < Literal::Result
	def initialize(error)
		@error = error
	end
end
