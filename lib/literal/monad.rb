# frozen_string_literal: true

module Literal::Monad
	def bind
		yield @value
	end
end
