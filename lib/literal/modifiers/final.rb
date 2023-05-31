# frozen_string_literal: true

module Literal::Modifiers::Final
	def final(method_name)
		final_methods[method_name] = true
		method_name
	end

	def method_added(method_name)
		if final_methods[method_name]
			raise "Method #{method_name} is final and cannot be overridden."
		end
	end

	def final_methods
		return @final_methods if defined?(@final_methods)

		if is_a?(Class) && superclass.is_a?(Literal::Modifiers)
			@final_methods = superclass.final_methods.dup
		else
			@final_methods = Concurrent::Map.new
		end
	end
end
