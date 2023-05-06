# frozen_string_literal: true

class Literal::Value::FloatValue < Literal::Value
	def __type__ = Float

	alias_method :to_f, :value
end
