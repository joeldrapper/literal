# frozen_string_literal: true

module Literal::Memoized
	def reset_memoized
		@__memoized__ = Concurrent::Map.new
	end
end
