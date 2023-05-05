# frozen_string_literal: true

class Literal::Struct
	extend Literal::Types

	class << self
		def attribute(name, type, reader: :public, writer: :public)
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
							"raise ::Literal::TypeError unless @__schema__[:#{n}] === #{n}"
						}.join("\n")
					}

					@attributes = {
						#{
							__schema__.map { |n, _t|
								"#{n}: #{n}"
							}.join(",\n")
						}
					}
				end

				def #{writer_name}(value)
					type = @__schema__[:#{name}]

					unless type === value
						raise Literal::TypeError, "Expected `\#{value.inspect}` to be a `\#{type.inspect}`."
					end

					@attributes[:#{name}] = value
				end

				def #{name}
					@attributes[:#{name}]
				end
			RUBY

			case writer
				when :public then nil
				when :protected then protected writer_name
				else private writer_name
			end

			case reader
				when :public then nil
				when :protected then protected name
				else private name
			end

			name
		end

		def __schema__
			return @__schema__ if defined?(@__schema__)

			@__schema__ = superclass.is_a?(self) ? superclass.__schema__.dup : {}
		end
	end

	def to_h
		@attributes.dup
	end
end
