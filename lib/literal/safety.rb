# frozen_string_literal: true

module Literal::Safety
	def abstract!
		@abstract = true
	end

	def abstract?
		@abstract ||= false
	end

	def abstract_method(method_name)
		abstract_methods << method_name
	end

	def abstract_methods
		return @abstract_methods if defined?(@abstract_methods)

		@abstract_methods = superclass.respond_to?(:abstract_methods) ? superclass.abstract_methods.dup : []
	end

	def inherited(subclass)
		TracePoint.new(:end) do |tp|
			if tp.self == subclass
				unless subclass.abstract?
					subclass.abstract_methods.each do |method_name|
						unless subclass.instance_methods.include?(method_name)
							raise "`#{subclass.inspect}` must implement `#{method_name.inspect}`."
						end
					end
				end

				tp.disable
			end
		end.enable
	end
end
