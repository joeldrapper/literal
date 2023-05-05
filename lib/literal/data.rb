# frozen_string_literal: true

class Literal::Data < Literal::Struct
	class << self
		def attribute(name, type, reader: :public)
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
								"#{n}: #{n}.frozen? ? #{n} : #{n}.dup"
							}.join(",\n")
						}
					}

					freeze
				end

				def #{name}
					@attributes[:#{name}]
				end
			RUBY

			case reader
				when :public then nil
				when :protected then protected name
				else private name
			end

			name
		end
	end

	attr_reader :attributes
	protected :attributes

	def with(**attributes)
		copy = dup

		attributes.each do |name, value|
			type = @__schema__[name]
			raise Literal::TypeError, "Expected #{name}: `#{value.inspect}` to be: `#{type.inspect}.`" unless type === value

			copy.attributes[name] = value
		end

		copy
	end

	def freeze
		@attributes.each_value(&:freeze)
		super
	end
end
