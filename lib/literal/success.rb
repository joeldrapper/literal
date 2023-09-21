# frozen_string_literal: true

class Literal::Success < Literal::Result
	# @return [String]
	def inspect = "Literal::Success(#{@value.inspect})"

	# @return [true]
	def success? = true

	# @return [false]
	def failure? = false

	# @return [Literal::Some]
	def success
		Literal::Some.new(@value)
	end

	# @return [Literal::NothingClass]
	def failure
		Literal::Nothing
	end

	def raise! = self

	def value_or_raise! = @value

	def value_or
		if block_given?
			@value
		else
			raise Literal::ArgumentError, "Expected block."
		end
	end

	# @return [Literal::Maybe]
	def filter
		yield(@value) ? Literal::Some.new(@value) : Literal::Nothing
	end

	def map(type)
		raise Literal::ArgumentError, "Expected block." unless block_given?

		output = yield(@value)

		if type === output
			@type.success(output)
		else
			raise Literal::TypeError.expected(output, to_be_a: type)
		end
	end

	def then(type)
		output = yield(@value)

		if Literal::Result(type) === output
			output
		else
			raise Literal::TypeError.expected(output, to_be_a: Literal::Result(type))
		end
	end

	def fmap
		@type.success(yield @value)
	end

	def bind
		yield @value
	end

	def deconstruct_keys(keys)
		if @value.respond_to?(:deconstruct_keys)
			@value.deconstruct_keys(keys)
		else
			{ value: @value }
		end
	end

	def map_failure(value_type = Exception)
		raise Literal::ArgumentError, "Expected block." unless block_given?

		self
	end

	def call(&block)
		if block
			Literal::ResultCase.new(@type, &block).with_success(@value)
		else
			self
		end
	end

	alias_method :handle, :call
end
