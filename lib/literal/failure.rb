# frozen_string_literal: true

class Literal::Failure < Literal::Result
	EXCEPTION_DECONSTRUCT_KEYS = [:detailed_message, :backtrace, :backtrace_locations, :cause, :full_message, :message, :exception]
	DECONSTRUCTION_TEMPLATE = EXCEPTION_DECONSTRUCT_KEYS.each_with_object({}) do |key, hash|
		hash[key] = -> (error) { error.send(key) if error.respond_to?(key) }
	end

	# @return [String]
	def inspect = "Literal::Failure(#{@value.inspect})"

	# @return [false]
	def success? = false

	# @return [true]
	def failure? = true

	# @return [Literal::NothingClass]
	def success = Literal::Nothing

	# @return [Literal::Some]
	def failure
		Literal::Some.new(@value)
	end

	def raise!
		raise(@value)
	end

	def value_or_raise!
		raise(@value)
	end

	def value_or
		yield(@value)
	end

	def filter = Literal::Nothing
	def map(type) = self
	def then(type) = self
	def fmap = self
	def bind = self

	def deconstruct_keys(keys)
		DECONSTRUCTION_TEMPLATE.slice(*keys).transform_values { |v| v.call(@value) }
	end

	def map_failure(type = Exception)
		output = yield(@value)

		unless Exception === output
			raise Literal::TypeError.expected(output, to_be_a: Exception)
		end

		unless type === output
			raise Literal::TypeError.expected(output, to_be_a: type)
		end

		Literal::Failure.new(output)
	end

	def call(&block)
		if block
			Literal::ResultCase.new(@type, &block).with_failure(@value)
		else
			self
		end
	end

	alias_method :handle, :call
end
