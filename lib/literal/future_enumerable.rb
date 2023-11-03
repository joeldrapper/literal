# frozen_string_literal: true

class Literal::FutureEnumerable
	include Enumerable
	def initialize(type, task)
		@type = type
		@task = task
	end

	attr_reader :type

	def each
		output = @task.wait

		if Enumerable === output
			output.each do |item|
				if @type === item
					yield(item)
				else
					raise ::Literal::TypeError.expected(item, to_be_a: @type)
				end
			end
		else
			raise Literal::TypeError.expected(output, to_be_a: Enumerable)
		end

		self
	end
end
