# frozen_string_literal: true

class Literal::VariantType < Literal::Generic
	def initialize(*types)
		@types = types
	end

	def inspect = "Literal::Variant(#{@types.inspect})"

	alias_method :===, :==

	# Create a new variant
	def new(value = Literal::Null)
		if Literal::Null != value
			Literal::Variant.new(value, *@types)
		elsif block_given?
			Literal::Variant.new(yield, *@types)
		else
			raise Literal::ArgumentError, "A value or block must be provided."
		end
	end

	# Will rescue and return any exception that is a member of the variant union.
	def try
		begin
			value = yield
		rescue *exception_types => e
			value = e
		end

		Literal::Variant.new(value, *@types)
	end

	# Will rescue and return given exceptions, as long as they are members of the variant union.
	def rescue(*exceptions)
		exceptions.each do |exception|
			unless Class === exception && exception < Exception
				raise Literal::TypeError, "The exception must be a subclass of Exception."
			end

			unless @types.include?(exception)
				raise Literal::ArgumentError, "The exception must be a member of the variant union."
			end
		end

		begin
			value = yield
		rescue *exceptions => e
			value = e
		end

		Literal::Variant.new(value, *@types)
	end

	private

	def exception_types
		@types.select { |type| Class === type && type < Exception }
	end
end
