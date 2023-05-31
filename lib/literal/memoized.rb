# frozen_string_literal: true

module Literal::Memoized
	def reset_memoized
		@memoized = Concurrent::Map.new
	end
end
