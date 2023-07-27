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

		abstract_methods << instance_method(method_name)

		define_method(method_name) do |*, **|
			raise NoMethodError, "You called an abstract method that hasn't been implemented by `#{self.class}`."
		end

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
				next unless it.method_defined?(abstract_method.name)

				method = it.instance_method(abstract_method.name)

				if method == abstract_method
					raise "Abstract method `##{abstract_method.name}` not implemented in `#{it}`."
				end

				sig = abstract_method.parameters.map(&:first)
				sig_req = sig.count(:req)
				sig_keyreq = sig.count(:keyreq)

				imp = method.parameters.map(&:first)
				imp_req = imp.count(:req)
				imp_keyreq = imp.count(:keyreq)

				# If the required arguments are the same,
				# or the implementation has a rest argument (*/**),
				# or the signature has a rest argument (*/**)
				# 	and the implementation has at least as many required arguments as the signature.

				positional_match = sig_req == imp_req || imp.include?(:rest) || (sig.include?(:rest) && imp_req >= sig_req)
				keyword_match = sig_keyreq == imp_keyreq || imp.include?(:keyrest) || (sig.include?(:keyrest) && imp_keyreq >= sig_keyreq)

				unless positional_match && keyword_match
					raise "Abstract method `##{abstract_method.name}` not implemented in `#{it}`."
				end
			end
		end
	end
end
