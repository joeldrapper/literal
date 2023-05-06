# frozen_string_literal: true

class Literal::Value::IntegerValue < Literal::Value
	def __type__ = Integer

	alias_method :to_i, :value
	alias_method :to_int, :value
end
