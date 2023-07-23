# frozen_string_literal: true

class Literal::Case
	def initialize(*required_cases, &)
		@required_cases = required_cases
		@handled_cases = {}

		yield self

		freeze

		keys = @handled_cases.keys

		excess_cases = keys - @required_cases
		missing_cases = @required_cases - keys

		if excess_cases.any?
			raise ArgumentError, "Excess case(s): #{excess_cases.join(', ')}."
		end

		if missing_cases.any?
			raise ArgumentError, "Missing case(s): #{missing_cases.join(', ')}."
		end
	end

	def when(*conditions, &block)
		conditions.each do |condition|
			@handled_cases[condition] = block
		end
	end

	def to_proc
		method(:call).to_proc
	end

	def call(value, ...)
		self[value]&.call(value, ...)
	end

	def [](value)
		@handled_cases.each do |condition, block|
			return block if condition === value
		end

		nil
	end
end
