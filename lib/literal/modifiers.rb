# frozen_string_literal: true

module Literal::Modifiers
	def self.extended(sub)
		sub.extend(Literal::Modifiers::Sig)
		sub.extend(Literal::Modifiers::Final)
		sub.extend(Literal::Modifiers::Memoize)
		sub.extend(Literal::Modifiers::Abstract)
		sub.extend(Literal::Modifiers::Deprecated)
	end
end
