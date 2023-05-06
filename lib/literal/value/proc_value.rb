# frozen_string_literal: true

class Literal::Value::ProcValue < Literal::Value
	def __type__ = Proc

	alias_method :to_proc, :value
end
