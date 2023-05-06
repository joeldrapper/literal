# frozen_string_literal: true

module Literal::Attributes
	include Literal::Types

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
						"raise ::Literal::TypeError unless @__schema__[:#{n}] === #{n}"
					}.join("\n")
				}

				#{
					__schema__.map { |n, _t|
						"@#{n} = #{n}"
					}.join("\n")
				}
			end

			def #{writer_name}(value)
				type = @__schema__[:#{name}]

				unless type === value
					raise Literal::TypeError, "Expected `\#{value.inspect}` to be a `\#{type.inspect}`."
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

	def __schema__
		return @__schema__ if defined?(@__schema__)

		@__schema__ = superclass.is_a?(self) ? superclass.__schema__.dup : {}
	end

	def self.extended(base)
		base.include(Literal::Initializer)
	end
end
