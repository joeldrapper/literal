# frozen_string_literal: true

class Literal::Failure < Literal::Result
	DECONSTRUCTION_TEMPLATE = {
		message: -> (error) { error.message },
		exception: -> (error) { error.exception },
		full_message: -> (error) { error.full_message },
		detailed_message: -> (error) { error.detailed_message }
	}

	# @return [String]
	def inspect = "Literal::Failure(#{@value.inspect})"

	# @return [false]
	def success? = false

	# @return [true]
	def failure? = true

	# @return [Literal::NothingClass]
	def success = Literal::Nothing

	# @return [Literal::Some]
	def failure = Literal::Some(@value)

	def raise!
		raise @value
	end

	alias_method :value_or_raise!, :raise!

	def value_or
		yield(@value)
	end

	def fmap = self
	def map(type = nil) = self
	def bind = self
	def then(type = nil) = self
	def filter = self

	def deconstruct
		[@value]
	end

	def deconstruct_keys(keys)
		DECONSTRUCTION_TEMPLATE.slice(*keys).transform_values { |v| v.call(@value) }
	end

	def lift(*, &block)
		if block
			Literal::Lift.new(*, &block).with_failure(@value)
		else
			self
		end
	end

	def lift!(*, &block)
		if block
			Literal::Lift.new(*, &block).with_failure!(@value)
		else
			self
		end
	end
end
