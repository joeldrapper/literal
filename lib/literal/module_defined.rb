# frozen_string_literal: true

module Literal::ModuleDefined
	module ClassMethods
		def after_defined
		end
	end

	def self.included(klass)
		klass.extend(ClassMethods)
	end
end

TracePoint.trace(:end) do |tp|
	if Class === tp.self && tp.self < Literal::ModuleDefined
		tp.self.after_defined
	end
end
