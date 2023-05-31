# frozen_string_literal: true

module Literal::Modifiers::Memoize
	def memoize(method_name, size: 100)
		original_method = instance_method(method_name)

		prepend extension = Module.new

		if original_method.arity == 0
			extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
			  # frozen_string_literal: true

				def #{method_name}
					cache = (@memoized ||= Concurrent::Map.new)
					cache.compute_if_absent(:#{method_name}) { super }
				end
			RUBY
		else
			extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
			  # frozen_string_literal: true

				def #{method_name}(*args)
					cache = (@memoized ||= Concurrent::Map.new)
					local_cache = cache[:#{method_name}] ||= Literal::LRU(Array, Literal::_Nilable(Literal::_Any)).new(#{size})
					local_cache.compute_if_absent(args) { super }
				end
			RUBY
		end

		method_name
	end
end
