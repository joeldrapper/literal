# frozen_string_literal: true

module Literal::Types
	include Literal::Monads

	# Matches if *any* given type is matched.
	def _Union(*types)
		raise Literal::ArgumentError, "_Union type must have at least two types." if types.size < 2

		Literal::Types::UnionType.new(*types)
	end

	# Matches if *all* given types are matched.
	def _Intersection(*types)
		raise Literal::ArgumentError, "_Intersection type must have at least two types." if types.size < 2

		Literal::Types::IntersectionType.new(*types)
	end

	# Matches if the given predicates are truthy.
	def _Is(*predicates)
		raise Literal::ArgumentError, "_Is type must have at least one predicate." if predicates.size < 1

		Literal::Types::IsType.new(*predicates)
	end

	# Matches if the value is an `Array` and all the elements match the given type.
	def _Array(type)
		Literal::Types::ArrayType.new(type)
	end

	# Matches if the value is a `Set` and all the elements match the given type.
	def _Set(type)
		Literal::Types::SetType.new(type)
	end

	#  Matches if the value is an `Enumerable` and all the elements match the given type.
	def _Enumerable(type)
		Literal::Types::EnumerableType.new(type)
	end

	# Matches if the value is a `Hash` and all the keys and values match the given types.
	def _Hash(key_type, value_type)
		Literal::Types::HashType.new(key_type, value_type)
	end

	# Matches if the value responds to all the given methods.
	def _Interface(*methods)
		raise Literal::ArgumentError, "_Interface type must have at least one method." if methods.size < 1

		Literal::Types::InterfaceType.new(*methods)
	end

	# Matches if the value is either `nil` or the given type.
	def _Nilable(type)
		Literal::Types::NilableType.new(type)
	end

	# Matches any value except `nil`. Use `_Nilable(_Any)` to match any value including `nil`.
	def _Any
		Literal::Types::AnyType
	end

	# Matches if the value is `true` or `false`.
	def _Boolean
		Literal::Types::BooleanType
	end

	# Matches if the value either the given class or a subclass of it.
	def _Class(type)
		Literal::Types::ClassType.new(type)
	end

	# Matches if the value is an `Enumerable` and each element matches the given types in order.
	def _Tuple(*types)
		raise Literal::ArgumentError, "_Tuple type must have at least one type." if types.size < 1

		Literal::Types::TupleType.new(*types)
	end

	# Matches if the value is an `Integer` and matches the given constraint.
	# You could use a `Range`, for example, as a constraint.
	# If you don't need a constraint, use `Integer` instead of `_Integer`.
	# @example
	# 	attribute :age, _Integer(18..127)
	def _Integer(constraint)
		Literal::Types::IntegerType.new(constraint)
	end

	# Matches if the value is a `Float` and matches the given constraint.
	# You could use a `Range`, for example, as a constraint.
	# If you don't need a constraint, use `Float` instead of `_Float`.
	def _Float(constraint)
		Literal::Types::FloatType.new(constraint)
	end

	# Matches if the value responds to `#call`.
	def _Callable(type = nil)
		Literal::Types::CallableType
	end

	# Matches if the value is a `Proc` or responds to `#to_proc`.
	def _Procable
		Literal::Types::ProcableType
	end

	# Matches if the value is a `Proc` and `#lambda?` returns truthy.
	def _Lambda
		Literal::Types::LambdaType
	end

	# Matches if the value is a `String` and matches the given constraint.
	# You could use a `Regexp`, for example, as a constraint.
	# If you don't need a constraint, use `String` instead of `_String`.
	def _String(constraint)
		Literal::Types::StringType.new(constraint)
	end

	# Matches if the given type is *not* matched.
	def _Not(type)
		Literal::Types::NotType.new(type)
	end

	# Matches *"truthy"* values (anything except `nil` and `false`).
	def _Truthy
		Literal::Types::TruthyType
	end

	# Matches *"falsy"* values (`nil` and `false`).
	def _Falsy
		Literal::Types::FalsyType
	end

	# Ensures a value matches the given schema for an Array or Hash.
	def _Schema(*array, **hash)
		Literal::Types::SchemaType.new(*array, **hash)
	end

	# Ensures the value is valid JSON data (i.e. it came from JSON.parse).
	def _JSONData
		Literal::Types::JSONDataType
	end

	# Matches if the value is *frozen*.
	def _Frozen(type)
		Literal::Types::FrozenType.new(type)
	end

	# Similar to `_Intersection`, but allows you to specify attribute constraints as keyword arguments.
	# @example
	# 	_Constraint(Array, size: 1..3)
	def _Constraint(*constraints, **attributes)
		Literal::Types::ConstraintType.new(*constraints, **attributes)
	end
end
