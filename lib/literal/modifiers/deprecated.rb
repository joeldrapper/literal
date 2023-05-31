# frozen_string_literal: true

module Literal::Modifiers::Deprecated
	def self.extended(sub)
		sub.include(Literal::Memoized)
		super
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
end
