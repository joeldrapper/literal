# frozen_string_literal: true

class Literal::VariantType < Literal::Type
	def initialize(*types)
		@types = types
	end

	def inspect = "Literal::Variant(#{@types.inspect})"

	alias_method :===, :==

	def new(value)
		Literal::Variant.new(value, *@types)
	end

	def try
		begin
			value = yield
		rescue *exception_types => e
			value = e
		end

		Literal::Variant.new(value, *@types)
	end

	def rescue(*exceptions)
		unless exceptions.all? { |exception| Class === exception && exception < Exception }
			raise Literal::TypeError
		end

		begin
			value = yield
		rescue *exceptions => e
			value = e
		end

		Literal::Variant.new(value, *@types, *exceptions)
	end

	private

	def exception_types
		@types.select { |type| Class === type && type < Exception }
	end
end
