# frozen_string_literal: true

class Literal::Types::SchemaType
	include Literal::Type

	def initialize(*array, **hash)
		@array = array.empty? ? nil : array
		@hash = hash.empty? ? nil : hash

		raise ArgumentError if @array && @hash
		raise ArgumentError unless @array || @hash
	end

	def inspect
		if @array
			"_Schema(#{@array.inspect})"
		else
			"_Schema(#{@hash.inspect})"
		end
	end

	def ===(other)
		if @array
			Array === other && (@array.size == other.size) && @array.each_with_index.all? { |t, i| t === other[i] }
		else
			Hash === other && (@hash.size == other.size) && @hash.all? { |k, t| t === other[k] }
		end
	end
end
