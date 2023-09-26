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
	def failure(error)
		if error === @value
			if block_given?
				yield(@value)
				self
			else
				Literal::Some.new(@value)
			end
		else
			block_given? ? self : Literal::Nothing
		end
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

	def filter = self
	def map(type) = self
	def then(type) = self
	def fmap = self
	def bind = self

	def deconstruct_keys(keys)
		DECONSTRUCTION_TEMPLATE.slice(*keys).transform_values { |v| v.call(@value) }
	end

	def handle!(*errors, &block)
		if errors.any? { |error| error === @value }
			block ? Literal::ResultCase.new(*errors, &block).with_failure!(@value) : self
		else
			raise @value
		end
	end

	def map_failure(type = Exception)
		output = yield(@value)

		unless Exception === output
			return Literal::Failure.new(
				Literal::TypeError.expected(output, to_be_a: Exception)
			)
		end

		unless type === output
			return Literal::Failure.new(
				Literal::TypeError.expected(output, to_be_a: type)
			)
		end

		Literal::Failure.new(output)
	rescue StandardError => e
		Literal::Failure.new(e)
	end

	def then_on_failure(result_type)
		output = yield(@value)

		unless Literal::Result(result_type) === output
			return Literal::Failure.new(
				Literal::TypeError.expected(output, to_be_a: Literal::Result(result_type))
			)
		end

		output
	rescue StandardError => e
		Literal::Failure.new(e)
	end
end
