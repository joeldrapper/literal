# frozen_string_literal: true

module Literal::Modifiers::Sig
	if Literal::EXPENSIVE_TYPE_CHECKS
		def sig(method_name, **signature)
			raise ArgumentError unless signature.size == 1

			types = signature.keys[0]
			return_type = signature.values[0]
			keywords = types[-1].is_a?(Hash) ? types.pop : {}
			original_method = instance_method(method_name)

			define_method(method_name) do |*a, **k, &b|
				types.each_with_index do |type, index|
					unless type === a[index]
						raise Literal::TypeError.expected(a[index], to_be_a: type)
					end
				end

				keywords.each do |key, type|
					unless type === k[key]
						raise Literal::TypeError.expected(k[key], to_be_a: type)
					end
				end

				output = original_method.bind(self).call(*a, **k, &b)

				unless return_type === output
					raise Literal::TypeError.expected(output, to_be_a: return_type)
				end

				output
			end

			method_name
		end
	else
		def sig(method_name, **signature)
			method_name
		end
	end
end
