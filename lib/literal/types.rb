# frozen_string_literal: true

module Literal::Types
	def _Union(*types)
		raise Literal::ArgumentError, "Union type must have at least two types." if types.size < 2

		Literal::Types::UnionType.new(*types)
	end

	def _Array(type)
		Literal::Types::ArrayType.new(type)
	end

	def _Set(type)
		Literal::Types::SetType.new(type)
	end

	def _Enumerable(type)
		Literal::Types::EnumerableType.new(type)
	end

	def _Hash(key_type, value_type)
		Literal::Types::HashType.new(key_type, value_type)
	end

	def _Interface(*methods)
		raise Literal::ArgumentError, "Interface type must have at least one method." if methods.size < 1

		Literal::Types::InterfaceType.new(*methods)
	end

	def _Maybe(type)
		_Union(type, nil)
	end

	def _Any
		Literal::Types::AnyType
	end

	def _Boolean
		Literal::Types::BooleanType
	end

	def _Class(type)
		Literal::Types::ClassType.new(type)
	end

	def _Tuple(*types)
		raise Literal::ArgumentError, "Tuple type must have at least one type." if types.size < 1

		Literal::Types::TupleType.new(*types)
	end

	def _Integer(range)
		Literal::Types::IntegerType.new(range)
	end

	def _Float(range)
		Literal::Types::FloatType.new(range)
	end
end
