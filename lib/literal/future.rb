# frozen_string_literal: true

class Literal::Future
	def initialize(type, task)
		@type = type
		@task = task
	end

	attr_reader :type

	def wait
		output = @task.wait
		if @type === output
			output
		else
			raise Literal::TypeError.expected(output, to_be_a: @type)
		end
	end

	def running?
		@task.running?
	end

	def then(type)
		output = yield(wait)

		if type === output
			output
		else
			raise Literal::TypeError.expected(output, to_be_a: type)
		end
	end
end
