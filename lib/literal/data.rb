# frozen_string_literal: true

class Literal::Data
	Attribute = Data.define(:name, :type, :reader, :default)

	extend Literal::Types
	extend Literal::Schema

	class << self
		def attribute(name, type, reader: :public, &default)
			__schema__[name] = Attribute.new(
				name:, type:, reader:, default:
			)

			include extension = Module.new

			extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
				# frozen_string_literal: true

				def initialize(#{
					__schema__.each_value.map { |attribute|
						"#{attribute.name}: #{attribute.default || attribute.type.nil? ? 'nil' : nil}"
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

					@__attributes__ = {
						#{
							__schema__.each_key.map { |n|
								"#{n}: #{n}.frozen? ? #{n} : #{n}.dup"
							}.join(",\n")
						}
					}

					freeze
				end
			RUBY

			if reader
				extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
					# frozen_string_literal: true

					def #{name}
						@__attributes__[:#{name}]
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

	def with(**new_attributes)
		new_attributes.each do |name, value|
			unless (attribute = @__schema__[name])
				raise Literal::ArgumentError, "Unknown attribute `#{name.inspect}`."
			end

			unless attribute.type === value
				raise Literal::TypeError.expected(value, to_be_a: attribute.type)
			end

			new_attributes[name] = value.frozen? ? value : value.dup
		end

		copy = dup
		copy.instance_variable_set(:@__attributes__, @__attributes__.dup.merge(new_attributes))
		copy.freeze
		copy
	end

	def freeze
		@__attributes__.each_value(&:freeze)
		super
	end
end
