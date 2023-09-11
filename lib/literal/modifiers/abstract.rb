# frozen_string_literal: true

module Literal::Modifiers::Abstract
	def abstract!
		@abstract = true
	end

	def abstract?
		!!@abstract
	end

	def abstract(method_name)
		@abstract = true

		abstract_methods << Literal::Method.new(method_name, self)

		method_name
	end

	def included(submodule)
		submodule.extend(Literal::Modifiers::Abstract)
		submodule.abstract_methods.concat(abstract_methods)

		super
	end

	def abstract_methods
		return @abstract_methods if defined?(@abstract_methods)

		if is_a?(Class) && superclass.is_a?(Literal::Modifiers::Abstract)
			@abstract_methods = superclass.abstract_methods.dup
		else
			@abstract_methods = Concurrent::Array.new
		end
	end
end

if Literal::TRACING
	TracePoint.trace(:end) do |tp|
		it = tp.self

		if it.is_a?(Literal::Modifiers::Abstract) && !it.abstract?
			it.abstract_methods.each do |abstract_method|
				method = Literal::Method.new(abstract_method.name, it)

				unless method < abstract_method
					raise "Abstract method `##{abstract_method.name}` not implemented in `#{it}`."
				end
			end
		end
	end
end
