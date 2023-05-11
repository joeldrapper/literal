# frozen_string_literal: true

module Literal::Types
	include Literal::Monads

	def self.ensure!(value = nil, type:)
		unless type === value
			raise Literal::TypeError.expected(value, to_be_a: type)
		end
	end

	def _Union(*types)
		raise Literal::ArgumentError, "_Union type must have at least two types." if types.size < 2

		Literal::Types::UnionType.new(*types)
	end

	def _Intersection(*types)
		raise Literal::ArgumentError, "_Intersection type must have at least two types." if types.size < 2

		Literal::Types::IntersectionType.new(*types)
	end

	def _Is(*predicates)
		raise Literal::ArgumentError, "_Is type must have at least one predicate." if predicates.size < 1

		Literal::Types::IsType.new(*predicates)
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
		raise Literal::ArgumentError, "_Interface type must have at least one method." if methods.size < 1

		Literal::Types::InterfaceType.new(*methods)
	end

	def _Nilable(type)
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
		raise Literal::ArgumentError, "_Tuple type must have at least one type." if types.size < 1

		Literal::Types::TupleType.new(*types)
	end

	def _Integer(range)
		Literal::Types::IntegerType.new(range)
	end

	def _Float(range)
		Literal::Types::FloatType.new(range)
	end

	def _Callable(type = nil)
		Literal::Types::CallableType
	end

	def _String(range)
		Literal::Types::StringType.new(range)
	end

	def _Not(type)
		Literal::Types::NotType.new(type)
	end
end
