# frozen_string_literal: true

class Literal::Struct
	Attribute = Data.define(:name, :type, :reader, :writer, :default)

	extend Literal::Types
	extend Literal::Schema

	class << self
		def attribute(name, type, reader: :public, writer: :public, &default)
			__schema__[name] = Attribute.new(
				name:, type:, reader:, writer:, default:
			)

			include extension = Module.new

			extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
				# frozen_string_literal: true

				def initialize(#{
					__schema__.each_value.map { |attribute|
						"#{attribute.name}: #{attribute.default || attribute.type === nil ? 'nil' : nil}"
					}.join(', ')
				})
					@__schema__ = self.class.__schema__

					#{
						__schema__.each_value.map { |attribute|
							"
								attribute = @__schema__[:#{attribute.name}]

								#{
									if attribute.default
										"#{attribute.name} ||= attribute.default.call"
									end
								}

								unless attribute.type === #{attribute.name}
									raise ::Literal::TypeError.expected(#{attribute.name}, to_be_a: attribute.type)
								end
							"
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
				writer_name = :"#{name}="

				extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
					# frozen_string_literal: true

					def #{writer_name}(value)
						attribute = @__schema__[:#{name}]

						unless attribute.type === value
							raise Literal::TypeError.expected(value, to_be_a: attribute.type)
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
				extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
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
