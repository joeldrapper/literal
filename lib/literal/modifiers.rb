# frozen_string_literal: true

module Literal::Modifiers
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

	def final(method_name)
		final_methods[method_name] = true
		method_name
	end

	def deprecated(method_name)
		deprecated_method_name = :"__deprecated_#{method_name}"
		alias_method deprecated_method_name, method_name

		define_method(method_name) do |*args, **kwargs, &block|
			warn <<~MESSAGE
				\nThe method `#{self.class}##{method_name}` is deprecated and will be removed in a future version.
				  Call site: #{caller_locations.first}
			MESSAGE

			send(deprecated_method_name, *args, **kwargs, &block)
		end

		method_name
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

	def included(submodule)
		submodule.extend(Literal::Modifiers)
		submodule.abstract_methods.concat(abstract_methods)

		inherited(submodule)
	end

	def method_added(method_name)
		if final_methods[method_name]
			raise "Method #{method_name} is final and cannot be overridden."
		end
	end

	def abstract_methods
		return @abstract_methods if defined?(@abstract_methods)

		if is_a?(Class) && superclass.is_a?(Literal::Modifiers)
			@abstract_methods = superclass.abstract_methods.dup
		else
			@abstract_methods = Concurrent::Array.new
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
