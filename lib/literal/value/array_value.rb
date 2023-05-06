# frozen_string_literal: true

class Literal::Value::ArrayValue < Literal::Value
	def __type__ = Array

	alias_method :to_a, :value
	alias_method :to_ary, :value
end
