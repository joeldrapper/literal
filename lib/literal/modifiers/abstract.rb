# frozen_string_literal: true

TracePoint.trace(:end, :b_return) do |tp|
	it = tp.self

	if it.is_a?(Literal::Modifiers::Abstract) && !it.abstract?
		it.abstract_methods.each do |abstract_method|
			unless it.method_defined?(abstract_method.name) && it.instance_method(abstract_method.name) != abstract_method
				raise "Abstract method `##{abstract_method.name}` not implemented in `#{it}`."
			end
		end
	end
end

module Literal::Modifiers::Abstract
	def abstract!
		@abstract = true
	end

	def abstract?
		!!@abstract
	end

	def abstract(method_name)
		abstract_methods << instance_method(method_name)
		method_name
	end

	def included(submodule)
		submodule.extend(Literal::Modifiers)
		submodule.abstract_methods.concat(abstract_methods)
	end

	def abstract_methods
		return @abstract_methods if defined?(@abstract_methods)

		if is_a?(Class) && superclass.is_a?(Literal::Modifiers)
			@abstract_methods = superclass.abstract_methods.dup
		else
			@abstract_methods = Concurrent::Array.new
		end
	end
end
