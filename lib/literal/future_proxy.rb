# frozen_string_literal: true

class Literal::FutureProxy < BasicObject
	def initialize(type, task)
		@type = type
		@task = task
	end

	attr_reader :type

	def method_missing(...)
		output = @task.wait
		if @type === output
			output.public_send(...)
		else
			raise ::Literal::TypeError.expected(output, to_be_a: @type)
		end
	end
end
