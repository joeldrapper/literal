# frozen_string_literal: true

module Literal::Attributes
	include Literal::Types
	include Literal::Schema

	def attribute(name, type, reader: false, writer: :private)
		__schema__[name] = type

		writer_name = :"#{name}="

		class_eval <<~RUBY, __FILE__, __LINE__ + 1
			# frozen_string_literal: true

			def initialize(#{
				__schema__.map { |n, t|
					"#{n}: #{t.nil? ? 'nil' : ''}"
				}.join(', ')
			})
				@__schema__ = self.class.__schema__

				#{
					__schema__.each_key.map { |n|
						"
							type = @__schema__[:#{n}]
							unless type === #{n}
								raise ::Literal::TypeError.expected(#{n}, to_be_a: type)
							end
						"
					}.join("\n")
				}

				#{
					__schema__.each_key.map { |n|
						"@#{n} = #{n}"
					}.join("\n")
				}
			end

			def #{writer_name}(value)
				type = @__schema__[:#{name}]

				unless type === value
					raise Literal::TypeError.expected(value, to_be_a: type)
				end

				@#{name} = value
			end
		RUBY

		case writer
			when :public then nil
			when :protected then protected writer_name
			else private writer_name
		end

		if reader
			attr_reader name

			case reader
				when :public then nil
				when :protected then protected name
				else private name
			end
		end

		name
	end
end
