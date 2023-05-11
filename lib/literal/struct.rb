# frozen_string_literal: true

class Literal::Struct
	extend Literal::Types
	extend Literal::Schema

	class << self
		def attribute(name, type, reader: :public, writer: :public)
			__schema__[name] = type

			writer_name = :"#{name}="

			include initializer = Module.new

			initializer.module_eval <<~RUBY, __FILE__, __LINE__ + 1
				# frozen_string_literal: true

				def initialize(#{
					__schema__.map { |n, t|
						"#{n}: #{t.nil? ? 'nil' : ''}"
					}.join(', ')
				})
					@__schema__ = self.class.__schema__

					#{
						__schema__.each_key.map { |n|
							"raise ::Literal::TypeError unless @__schema__[:#{n}] === #{n}"
						}.join("\n")
					}

					@attributes = {
						#{
							__schema__.each_key.map { |n|
								"#{n}: #{n}"
							}.join(",\n")
						}
					}
				end
			RUBY

			if writer
				initializer.module_eval <<~RUBY, __FILE__, __LINE__ + 1
					# frozen_string_literal: true

					def #{writer_name}(value)
						type = @__schema__[:#{name}]

						unless type === value
							raise Literal::TypeError.expected(value, to_be_a: type)
						end

						@attributes[:#{name}] = value
					end
				RUBY

				case writer
				when :public
					public writer_name
				when :protected
					protected writer_name
				else
					private writer_name
				end
			end

			if reader
				initializer.module_eval <<~RUBY, __FILE__, __LINE__ + 1
					# frozen_string_literal: true

					def #{name}
						@attributes[:#{name}]
					end
				RUBY

				case reader
				when :public
					public name
				when :protected
					protected name
				else
					private name
				end
			end

			name
		end
	end

	def to_h
		@attributes.dup
	end
end
