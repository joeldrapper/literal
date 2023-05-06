# frozen_string_literal: true

class SomeOperation < Literal::Operation
	def call
	end
end

test do
	result = SomeOperation.call
	binding.irb
end
