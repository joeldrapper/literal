# frozen_string_literal: true

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

		inherited(submodule)
	end

	def inherited(subclass)
		TracePoint.trace(:end) do |tp|
			if tp.self == subclass
				unless subclass.abstract?
					abstract_methods.each do |abstract_method|
						unless subclass.method_defined?(abstract_method.name) && subclass.instance_method(abstract_method.name) != abstract_method
							raise "Abstract method `##{abstract_method.name}` not implemented in `#{subclass}`."
						end
					end
				end

				tp.disable
			end
		end.enable
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
