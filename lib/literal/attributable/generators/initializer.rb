# frozen_string_literal: true

module Literal::Attributable::Generators
	class Initializer < Base
		def initialize(attributes)
			@attributes = attributes
		end

		def template
			Def.new(
				visibility: :public,
				name: "initialize",
				params:,
				body:,
			)
		end

		private

		def params
			@attributes.each_value.map do |attribute|
				case attribute.kind
				when :*
					PositionalSplat.new(attribute:)
				when :**
					KeywordSplat.new(attribute:)
				when :&
					BlockParam.new(attribute:)
				when :positional
					if attribute.default
						PositionalParam.new(
							name: attribute.name,
							default: "Literal::Null",
						)
					elsif attribute.type === nil
						PositionalParam.new(
							name: attribute.name,
							default: "nil",
						)
					else
						PositionalParam.new(
							name: attribute.name,
							default: nil,
						)
					end
				else
					KeywordParam.new(attribute:)
				end
			end
		end

		def body
			[
				assign_schema,
				handle_attributes,
				initializer_callback,
			]
		end

		def assign_schema
			AssignSchema.new
		end

		def handle_attributes
			Section.new(
				name: "Handle attributes",
				body: @attributes.each_value.map do |attribute|
					Section.new(
						name: attribute.name,
						body: [
							escape_keyword(attribute),
							coerce_attribute(attribute),
							assign_default(attribute),
							check_type(attribute),
							assign_value(attribute),
						].compact,
					)
				end,
			)
		end

		def escape_keyword(attribute)
			KeywordEscape.new(attribute) if attribute.ruby_keyword?
		end

		def coerce_attribute(attribute)
			AttributeCoercion.new(attribute) if attribute.coercion
		end

		def assign_default(attribute)
			DefaultAssignment.new(attribute) if attribute.default
		end

		def check_type(attribute)
			TypeCheck.new(
				attribute_name: attribute.name,
				variable_name: attribute.escaped_name,
			)
		end

		def initializer_callback
			InitializerCallback.new
		end
	end
end
