module Literal::Type
	extend Literal::Modifiers

	abstract_class!

	abstract_method :===
	abstract_method :inspect
end
