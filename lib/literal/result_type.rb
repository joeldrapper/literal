# frozen_string_literal: true

# @api private
class Literal::ResultType < Literal::Generic
	def initialize(type, *failure_types)
		@success_type = type

		@failure_type = Literal::_Union(*failure_types)

		freeze
	end

	attr_accessor :failure_type

	def inspect = "Literal::Result(#{@success_type.inspect}, #{@failure_type.inspect})"

	def new
		value = yield(self)

		if self === value
			value
		else
			raise Literal::TypeError.expected(value, to_be_a: self)
		end
	end

	def success(value)
		if @success_type === value
			Literal::Success.new(self, value)
		else
			raise Literal::TypeError.expected(value, to_be_a: @success_type)
		end
	end

	def failure(value)
		if @failure_type === value
			Literal::Failure.new(self, value)
		else
			raise Literal::TypeError.expected(value, to_be_a: @failure_type)
		end
	end

	def rescue(*exceptions, &)
		exceptions.each do |exception|
			unless @failure_type.types.include?(exception)
				raise Literal::ArgumentError, "The exception must be a valid failure type for `#{inspect}`."
			end
		end

		begin
			new(&)
		rescue *exceptions => e
			failure(e)
		end
	end

	def try(&)
		new(&)
	rescue *@failure_type.types => e
		failure(e)
	end

	def ===(value)
		case value
		when Literal::Success
			@success_type === value.value
		when Literal::Failure
			@failure_type === value.value
		else
			false
		end
	end
end
