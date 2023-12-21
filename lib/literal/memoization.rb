# frozen_string_literal: true

module Literal::Memoization
	def self.extended(base)
		base.include(Literal::Memoized)
	end

	def memoize(method_name, size: 100)
		visibility = if public_instance_methods.include?(method_name)
			:public
		elsif protected_instance_methods.include?(method_name)
			:protected
		else
			:private
		end

		original_method = instance_method(method_name)

		if original_method.parameters.any?
			define_method(method_name) do |*args|
				cache = @__memoized__ ||= Concurrent::Map.new

				parameterized_cache = cache[method_name] ||= Literal::LRU(Array, Literal::_Any).new(size)

				cached = parameterized_cache[args]

				if nil == cached
					parameterized_cache[args] = original_method.bind(self).call(*args)
				else
					cached
				end
			end
		else
			define_method(method_name) do
				cache = @__memoized__ ||= Concurrent::Map.new

				cached = cache[method_name]

				if nil == cached
					cache[method_name] = original_method.bind(self).call
				else
					cached
				end
			end
		end

		send(visibility, method_name)

		method_name
	end
end
