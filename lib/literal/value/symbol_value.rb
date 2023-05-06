# frozen_string_literal: true

class Literal::Value::SymbolValue < Literal::Value
	def __type__ = Symbol

	alias_method :to_sym, :value
end
