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
	def failure(error = nil)
		if nil == error || error === @value
			block_given? ? yield(@value) : Literal::Some.new(@value)
		else
			Literal::Nothing
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
	def map(type = nil) = self
	def then(type = nil) = self
	def fmap = self
	def bind = self

	def deconstruct_keys(keys)
		DECONSTRUCTION_TEMPLATE.slice(*keys).transform_values { |v| v.call(@value) }
	end

	def lift(*, &block)
		block ? Literal::Lift.new(*, &block).with_failure(@value) : self
	end

	def lift!(*, &block)
		block ? Literal::Lift.new(*, &block).with_failure!(@value) : self
	end
end
