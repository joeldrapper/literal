# frozen_string_literal: true

class Literal::Value::HashValue < Literal::Value
	def __type__ = Hash

	alias_method :to_h, :value
	alias_method :to_hash, :value
end
