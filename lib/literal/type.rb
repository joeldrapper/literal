# frozen_string_literal: true

module Literal::Type
	def >=(other)
		(self > other) || (self == other)
	end
end
