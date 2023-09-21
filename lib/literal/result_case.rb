# frozen_string_literal: true

class Literal::ResultCase
	def initialize(type)
		@type = type
		@success = nil
		@failure_cases = {}
		@else = nil

		yield(self)
		freeze

		return if @else

		unless @success
			raise ArgumentError, "Missing success case."
		end

		required_failure_cases = @type.failure_type.types
		handled_failure_cases = @failure_cases.keys

		missing_failure_cases = required_failure_cases - handled_failure_cases
		excess_failure_cases = handled_failure_cases - required_failure_cases

		if missing_failure_cases.any?
			raise ArgumentError, "Missing failure case(s): #{missing_failure_cases.join(', ')}."
		end

		if excess_failure_cases.any?
			raise ArgumentError, "Excess failure case(s): #{excess_failure_cases.join(', ')}."
		end
	end

	def with_success(value)
		raise ArgumentError unless frozen?

		if @success
			@success.call(value)
		else
			@else.call(value)
		end
	end

	def with_failure(value)
		raise ArgumentError unless frozen?

		@failure_cases.each do |condition, block|
			return block.call(value) if condition === value
		end

		@else.call(value)
	end

	def on_success(&block)
		@success = block || Literal::IdentityProc
	end

	def on_failure(*cases, &block)
		raise ArgumentError if cases.length == 0

		cases.each do |condition|
			@failure_cases[condition] = block || Literal::IdentityProc
		end
	end

	def else(&block)
		@else = block || Literal::IdentityProc
	end
end
