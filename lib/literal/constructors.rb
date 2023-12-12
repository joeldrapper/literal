# frozen_string_literal: true

module Literal::Constructors
	SpecialisedEnums = {
		String => Class.new(Literal::Enum) do
			@type = String

			alias_method :to_s, :value
			alias_method :to_str, :value
		end,

		Integer => Class.new(Literal::Enum) do
			@type = Integer

			alias_method :to_i, :value
		end,

		Array => Class.new(Literal::Enum) do
			@type = Array

			alias_method :to_a, :value
			alias_method :to_ary, :value
		end
	}.freeze

	# @return [Literal::Array]
	def Array(type)
		Literal::ArrayType.new(type)
	end

	def Enum(type)
		SpecialisedEnums[type] || Class.new(Literal::Enum) do
			@type = type
		end
	end

	# @return [Literal::LRU]
	def LRU(key_type, value_type)
		Literal::LRUType.new(key_type, value_type)
	end

	# @return [Literal::Variant]
	def Variant(*types)
		if block_given?
			Literal::Variant.new(yield, *types)
		else
			Literal::VariantType.new(*types)
		end
	end

	# @return [Literal::Decorator]
	def Decorator(object_type)
		Class.new(Literal::Decorator) do
			attribute :__object__, object_type, positional: true, reader: :public, writer: :private
		end
	end

	# @return [Literal::Union]
	def Union(*types)
		Literal::Union.new(*types)
	end

	def Value(type, &)
		value_class = Literal::ValueClasses[type]

		unless value_class
			raise Literal::ArgumentError, "Invalid value type."
		end

		Class.new(value_class, &)
	end
end
