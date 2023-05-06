# frozen_string_literal: true

class Literal::Value::StringValue < Literal::Value
	def __type__ = String

	alias_method :to_s, :value
	alias_method :to_str, :value
end
