# frozen_string_literal: true

class Literal::Lift
	def initialize(*required_failure_cases, &block)
		@success_case = nil
		@failure_case = nil

		@required_failure_cases = required_failure_cases
		@handled_failure_cases = {}

		if block.arity == 0
			instance_exec(&block)
		else
			yield(self)
		end

		keys = @handled_failure_cases.keys

		excess_cases = keys - @required_failure_cases
		missing_cases = @required_failure_cases - keys

		if excess_cases.any?
			raise ArgumentError, "Excess case(s): #{excess_cases.map(&:inspect).join(', ')}."
		end

		if missing_cases.any?
			raise ArgumentError, "Missing case(s): #{missing_cases.map(&:inspect).join(', ')}."
		end
	end

	def with_success(value)
		ensure_success_case! and ensure_failure_case!

		@success_case.call(value)
	end

	def with_success!(value)
		ensure_success_case!

		@success_case.call(value)
	end

	def with_failure(value)
		ensure_success_case! and ensure_failure_case!

		@handled_failure_cases.each do |condition, block|
			return block.call(value) if condition === value
		end

		@failure_case.call(value)
	end

	def with_failure!(value)
		ensure_success_case!

		@handled_failure_cases.each do |condition, block|
			return block.call(value) if condition === value
		end

		return @failure_case&.call(value)

		raise(value)
	end

	def success(&block)
		@success_case = block
	end

	def failure(*types, &block)
		if types.length == 0
			@failure_case = block
		else
			types.each do |type|
				@handled_failure_cases[type] = block || proc { |it| it }
			end
		end
	end

	private

	def ensure_success_case!
		@success_case ? true : raise(ArgumentError, "You need to define a success case.")
	end

	def ensure_failure_case!
		@failure_case ? true : raise(ArgumentError, "You need to define a failure case.")
	end
end
