# frozen_string_literal: true

class Literal::Value::SetValue < Literal::Value
	def __type__ = Set

	alias_method :to_set, :value
end
