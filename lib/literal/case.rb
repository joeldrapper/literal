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
			raise ArgumentError, "Excess case(s): #{excess_cases.map(&:inspect).join(', ')}."
		end

		if missing_cases.any?
			raise ArgumentError, "Missing case(s): #{missing_cases.map(&:inspect).join(', ')}."
		end
	end

	def when(*conditions, &block)
		conditions.each do |condition|
			@handled_cases[condition] = block || proc { |it| it }
		end
	end

	def to_proc
		method(:call).to_proc
	end

	def call(value, ...)
		block = self[value]
		if block
			block.call(value, ...)
		else
			raise Literal::ArgumentError
		end
	end

	def [](value)
		@handled_cases.each do |condition, block|
			return block if condition === value
		end

		nil
	end
end
