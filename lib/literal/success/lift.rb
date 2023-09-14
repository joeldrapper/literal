# frozen_string_literal: true

class Literal::Success::Lift
	def initialize(value, &block)
		@value = value
		@success_case = nil
		@catch_all_failure_case = nil

		if block.arity == 0
			instance_exec(&block)
		else
			yield(self)
		end
	end

	def call
		raise "No success case" unless @success_case
		raise "No failure case" unless @catch_all_failure_case

		@success_case.call(@value)
	end

	def call!
		raise "No success case" unless @success_case
		raise "Excessive failure case" if @catch_all_failure_case

		@success_case.call(@value)
	end

	def success(&block)
		@success_case = block
	end

	def failure(*types, &)
		# We already know this is a success, so we only care about tracking that a catch all failure case exists.
		if types.length == 0
			@catch_all_failure_case = true
		end
	end
end
