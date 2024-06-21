# frozen_string_literal: true

module Literal::Types
	autoload :AnyType, "literal/types/any_type"
	autoload :ArrayType, "literal/types/array_type"
	autoload :BooleanType, "literal/types/boolean_type"
	autoload :CallableType, "literal/types/callable_type"
	autoload :ClassType, "literal/types/class_type"
	autoload :ConstraintType, "literal/types/constraint_type"
	autoload :DescendantType, "literal/types/descendant_type"
	autoload :EnumerableType, "literal/types/enumerable_type"
	autoload :FalsyType, "literal/types/falsy_type"
	autoload :FloatType, "literal/types/float_type"
	autoload :FrozenType, "literal/types/frozen_type"
	autoload :HashType, "literal/types/hash_type"
	autoload :IntegerType, "literal/types/integer_type"
	autoload :InterfaceType, "literal/types/interface_type"
	autoload :IntersectionType, "literal/types/intersection_type"
	autoload :JSONDataType, "literal/types/json_data_type"
	autoload :LambdaType, "literal/types/lambda_type"
	autoload :MapType, "literal/types/map_type"
	autoload :NeverType, "literal/types/never_type"
	autoload :NilableType, "literal/types/nilable_type"
	autoload :NotType, "literal/types/not_type"
	autoload :ProcableType, "literal/types/procable_type"
	autoload :RangeType, "literal/types/range_type"
	autoload :SetType, "literal/types/set_type"
	autoload :ShapeType, "literal/types/shape_type"
	autoload :StringType, "literal/types/string_type"
	autoload :SymbolType, "literal/types/symbol_type"
	autoload :TruthyType, "literal/types/truthy_type"
	autoload :TupleType, "literal/types/tuple_type"
	autoload :VoidType, "literal/types/void_type"

	# Matches any value except `nil`. Use `_Nilable(_Any)` to match any value including `nil`.
	def _Any
		Literal::Types::AnyType
	end

	# Matches if the value is an `Array` and all the elements match the given type.
	def _Array(type)
		Literal::Types::ArrayType.new(type)
	end

	# Matches if the value is `true` or `false`.
	def _Boolean
		Literal::Types::BooleanType
	end

	# Matches if the value responds to `#call`.
	def _Callable(type = nil)
		Literal::Types::CallableType
	end

	# Matches if the value either the given class or a subclass of it.
	def _Class(type)
		Literal::Types::ClassType.new(type)
	end

	# Similar to `_Intersection`, but allows you to specify attribute constraints as keyword arguments.
	# @example
	# 	_Constraint(Array, size: 1..3)
	def _Constraint(*constraints, **attributes)
		Literal::Types::ConstraintType.new(*constraints, **attributes)
	end

	# Matches if the value is a descendant of the given class.
	def _Descendant(type)
		Literal::Types::DescendantType.new(type)
	end

	#  Matches if the value is an `Enumerable` and all its elements match the given type.
	def _Enumerable(type)
		Literal::Types::EnumerableType.new(type)
	end

	# Matches *"falsy"* values (`nil` and `false`).
	def _Falsy
		Literal::Types::FalsyType
	end

	# Matches if the value is a `Float` and matches the given constraint.
	# You could use a `Range`, for example, as a constraint.
	# If you don't need a constraint, use `Float` instead of `_Float`.
	def _Float(constraint)
		Literal::Types::FloatType.new(constraint)
	end

	# Matches if the value is *frozen*.
	def _Frozen(type)
		Literal::Types::FrozenType.new(type)
	end

	# Matches if the value is a `Hash` and all the keys and values match the given types.
	def _Hash(key_type, value_type)
		Literal::Types::HashType.new(key_type, value_type)
	end

	# Matches if the value is an `Integer` and matches the given constraint.
	# You could use a `Range`, for example, as a constraint.
	# If you don't need a constraint, use `Integer` instead of `_Integer`.
	# @example
	# 	attribute :age, _Integer(18..127)
	def _Integer(constraint)
		Literal::Types::IntegerType.new(constraint)
	end

	# Matches if the value responds to all the given methods.
	def _Interface(*methods)
		raise Literal::ArgumentError.new("_Interface type must have at least one method.") if methods.size < 1

		Literal::Types::InterfaceType.new(*methods)
	end

	# Matches if *all* given types are matched.
	def _Intersection(*types)
		raise Literal::ArgumentError.new("_Intersection type must have at least one type.") if types.size < 1

		Literal::Types::IntersectionType.new(*types)
	end

	# Ensures the value is valid JSON data (i.e. it came from JSON.parse).
	def _JSONData
		Literal::Types::JSONDataType
	end

	# Matches if the value is a `Proc` and `#lambda?` returns truthy.
	def _Lambda
		Literal::Types::LambdaType
	end

	def _Map(**shape)
		Literal::Types::MapType
	end

	# Never matches any value.
	def _Never
		Literal::Types::NeverType
	end

	# Matches if the value is either `nil` or the given type.
	def _Nilable(type)
		Literal::Types::NilableType.new(type)
	end

	# Matches if the given type is *not* matched.
	def _Not(type)
		Literal::Types::NotType.new(type)
	end

	# Matches if the value is a `Proc` or responds to `#to_proc`.
	def _Procable
		Literal::Types::ProcableType
	end

	# Matches if the value is a `Range` of the given type.
	def _Range(type)
		Literal::Types::RangeType.new(type)
	end

	# Matches if the value is a `Set` and all the elements match the given type.
	def _Set(type)
		Literal::Types::SetType.new(type)
	end

	# Ensures a value matches the given shape of a Hash
	def _Shape(*constraints, **shape)
		Literal::Types::ShapeType.new(*constraints, **shape)
	end

	# Matches if the value is a `String` and matches the given constraint.
	# You could use a `Regexp`, for example, as a constraint.
	# If you don't need a constraint, use `String` instead of `_String`.
	def _String(constraint)
		Literal::Types::StringType.new(constraint)
	end

	# Matches if the value is a `Symbol` and matches the given constraint.
	def _Symbol(constraint)
		Literal::Types::SymbolType.new(constraint)
	end

	# Matches *"truthy"* values (anything except `nil` and `false`).
	def _Truthy
		Literal::Types::TruthyType
	end

	# Matches if the value is an `Array` and each element matches the given types in order.
	def _Tuple(*types)
		raise Literal::ArgumentError.new("_Tuple type must have at least one type.") if types.size < 1

		Literal::Types::TupleType.new(*types)
	end

	# Matches if *any* given type is matched.
	def _Union(*types)
		raise Literal::ArgumentError.new("_Union type must have at least one type.") if types.size < 1

		Literal::Union.new(*types)
	end

	def _Void
		Literal::Types::VoidType
	end
end
