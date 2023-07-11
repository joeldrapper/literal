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
				body:
			)
		end

		private

		def params
			@attributes.each_value.map do |attribute|
				case attribute.special
				when :*
					PositionalSplat.new(attribute:)
				when :**
					KeywordSplat.new(attribute:)
				when :&
					BlockParam.new(attribute:)
				else
					if attribute.positional
						if attribute.default?
							PositionalParam.new(
								name: attribute.name,
								default: "Literal::Null"
							)
						elsif attribute.type === nil
							PositionalParam.new(
								name: attribute.name,
								default: "nil"
							)
						else
							PositionalParam.new(
								name: attribute.name,
								default: nil
							)
						end
					else
						KeywordParam.new(attribute:)
					end
				end
			end
		end

		def body
			[
				assign_schema,
				escape_keywords,
				coerce_attributes,
				assign_defaults,
				check_types,
				assign_values,
				initializer_callback
			]
		end

		def assign_schema
			AssignSchema.new
		end

		def escape_keywords
			Section.new(
				name: "Escape keywords",
				body: @attributes.each_value.select(&:escape?).map do |attribute|
					KeywordEscape.new(attribute)
				end.compact
			)
		end

		def coerce_attributes
			Section.new(
				name: "Coerce attributes",
				body: @attributes.each_value.select(&:coercion).map do |attribute|
					AttributeCoercion.new(attribute)
				end
			)
		end

		def assign_defaults
			Section.new(
				name: "Assign defaults",
				body: @attributes.each_value.select(&:default?).map do |attribute|
					DefaultAssignment.new(attribute)
				end
			)
		end

		def check_types
			Section.new(
				name: "Check types",
				body: @attributes.each_value.map do |attribute|
					TypeCheck.new(
						attribute_name: attribute.name,
						variable_name: attribute.escaped
					)
				end
			)
		end

		def initializer_callback
			InitializerCallback.new
		end
	end
end
