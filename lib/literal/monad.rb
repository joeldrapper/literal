# frozen_string_literal: true

class Literal::Monad
	extend Literal::Modifiers

	abstract_class!

	abstract_method :map
	abstract_method :then
	abstract_method :maybe
	abstract_method :filter
	abstract_method :handle
	abstract_method :value_or

	def bind
		yield @value
	end
end
