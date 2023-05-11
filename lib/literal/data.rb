# frozen_string_literal: true

class Literal::Data
	extend Literal::Types
	extend Literal::Schema

	class << self
		def attribute(name, type, reader: :public)
			unless Symbol === name
				raise Literal::TypeError.expected(name, to_be_a: Symbol)
			end

			unless _Interface(:===) === type
				raise Literal::TypeError.expected(type, to_be_a: _Interface(:===))
			end

			unless Literal::AccessorConfiguration === reader
				raise Literal::TypeError.expected(reader, to_be_a: Literal::AccessorConfiguration)
			end

			__schema__[name] = type

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
				initializer.module_eval <<~RUBY, __FILE__, __LINE__ + 1
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

	def with(**new_attributes)
		new_attributes.each do |name, value|
			unless (type = @__schema__[name])
				raise Literal::ArgumentError, "Unknown attribute `#{name.inspect}`."
			end

			unless type === value
				raise Literal::TypeError.expected(value, to_be_a: type)
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
