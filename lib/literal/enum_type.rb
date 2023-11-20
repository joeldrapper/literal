# frozen_string_literal: true

class Literal::EnumType < Literal::Type
	def initialize(type)
		@type = type
	end

	def inspect
		"Literal::Enum(#{@type.inspect})"
	end

	def ===(value)
		Literal::Enum === value && value.type == @type
	end

	def define(&)
		type = @type

		Class.new(Literal::Enum) do
			@type = type

			if Integer == type
				alias_method :to_i, :value
			elsif String == type
				alias_method :to_s, :value
			elsif Array == type
				alias_method :to_a, :value
			elsif Hash == type
				alias_method :to_h, :value
			end

			class_exec(&)
			deep_freeze
		end
	end
end
