# frozen_string_literal: true

class Literal::Failure::Lift
	def initialize(value, &block)
		@value = value
		@success_case = nil
		@specific_failure_case = nil
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

		@specific_failure_case&.call(@value) || @catch_all_failure_case.call(@value)
	end

	def call!
		raise "No success case" unless @success_case
		raise "Excessive failure case" if @catch_all_failure_case

		@specific_failure_case&.call(@value) || raise(@value)
	end

	def success
		# We already know this is a failure, so we only care about tracking that a success case exists.
		@success_case = true
	end

	def failure(*types, &block)
		if types.length == 0
			@catch_all_failure_case = block
		else
			types.each { |t| return @specific_failure_case = block if t === @value }
		end
	end
end
