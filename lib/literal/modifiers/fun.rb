# frozen_string_literal: true

module Literal::Modifiers::Fun
	def fun(name, sig, &)
		define_method(name, &)

		if Literal::EXPENSIVE_TYPE_CHECKS
			sig = sig.first

			arguments_signature = sig[0]
			return_type = sig[1]

			block_signature = arguments_signature[-1] == :& ? arguments_signature.pop : nil
			keyword_arguments_signature = Hash === arguments_signature[-1] ? arguments_signature.pop : {}

			extension = Module.new do
				define_method(name) do |*a, **k, &b|
					unless arguments_signature.size == a.size
						raise ArgumentError, "wrong number of arguments"
					end

					unless keyword_arguments_signature.size == k.size
						raise ArgumentError, "wrong number of keyword arguments"
					end

					if !!block_signature != !!b
						raise ArgumentError, "wrong number of block arguments"
					end

					arguments_signature.each_with_index do |type, index|
						unless type === a[index]
							raise Literal::TypeError.expected(a[index], to_be_a: type)
						end
					end

					keyword_arguments_signature.each do |key, type|
						unless type === k[key]
							raise Literal::TypeError.expected(k[key], to_be_a: type)
						end
					end

					return_value = super(*a, **k, &b)

					unless return_type === return_value
						raise Literal::TypeError.expected(return_value, to_be_a: return_type)
					end

					return_value
				end
			end

			prepend extension
		end
	end
end
