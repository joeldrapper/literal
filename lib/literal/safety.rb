module Literal::Safety
	def abstract_class!
		@abstract_class = true
	end

	def abstract_class?
		@abstract_class ||= false
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
				unless subclass.abstract_class?
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
