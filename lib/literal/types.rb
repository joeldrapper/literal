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

	# Matches any value except `nil`. Use `_Nilable(_Any)` or `_Void` to match any value including `nil`.
	def _Any
		Literal::Types::AnyType
	end

	# Matches if the value is an `Array` and all the elements match the given type.
	def _Array(...)
		Literal::Types::ArrayType.new(...)
	end

	# Matches if the value is `true` or `false`.
	def _Boolean
		Literal::Types::BooleanType
	end

	# Matches if the value responds to `#call`.
	def _Callable
		Literal::Types::CallableType
	end

	# Matches if the value either the given class or a subclass of it.
	def _Class(...)
		Literal::Types::ClassType.new(...)
	end

	# Similar to `_Intersection`, but allows you to specify attribute constraints as keyword arguments.
	# @example
	# 	_Constraint(Array, size: 1..3)
	def _Constraint(...)
		Literal::Types::ConstraintType.new(...)
	end

	# Matches if the value is a descendant of the given class.
	def _Descendant(...)
		Literal::Types::DescendantType.new(...)
	end

	#  Matches if the value is an `Enumerable` and all its elements match the given type.
	def _Enumerable(...)
		Literal::Types::EnumerableType.new(...)
	end

	# Matches *"falsy"* values (`nil` and `false`).
	def _Falsy
		Literal::Types::FalsyType
	end

	# Matches if the value is a `Float` and matches the given constraint.
	# You could use a `Range`, for example, as a constraint.
	# If you don't need a constraint, use `Float` instead of `_Float`.
	def _Float(...)
		Literal::Types::FloatType.new(...)
	end

	# Matches if the value is *frozen*.
	def _Frozen(...)
		Literal::Types::FrozenType.new(...)
	end

	# Matches if the value is a `Hash` and all the keys and values match the given types.
	def _Hash(...)
		Literal::Types::HashType.new(...)
	end

	# Matches if the value is an `Integer` and matches the given constraint.
	# You could use a `Range`, for example, as a constraint.
	# If you don't need a constraint, use `Integer` instead of `_Integer`.
	# @example
	# 	attribute :age, _Integer(18..127)
	def _Integer(...)
		Literal::Types::IntegerType.new(...)
	end

	# Matches if the value responds to all the given methods.
	def _Interface(...)
		Literal::Types::InterfaceType.new(...)
	end

	# Matches if *all* given types are matched.
	def _Intersection(...)
		Literal::Types::IntersectionType.new(...)
	end

	# Ensures the value is valid JSON data (i.e. it came from JSON.parse).
	def _JSONData
		Literal::Types::JSONDataType
	end

	# Matches if the value is a `Proc` and `#lambda?` returns truthy.
	def _Lambda
		Literal::Types::LambdaType
	end

	def _Map(...)
		Literal::Types::MapType.new(...)
	end

	# Never matches any value.
	def _Never
		Literal::Types::NeverType
	end

	# Matches if the value is either `nil` or the given type.
	def _Nilable(...)
		Literal::Types::NilableType.new(...)
	end

	# Matches if the given type is *not* matched.
	def _Not(...)
		Literal::Types::NotType.new(...)
	end

	# Matches if the value is a `Proc` or responds to `#to_proc`.
	def _Procable
		Literal::Types::ProcableType
	end

	# Matches if the value is a `Range` of the given type.
	def _Range(...)
		Literal::Types::RangeType.new(...)
	end

	# Matches if the value is a `Set` and all the elements match the given type.
	def _Set(...)
		Literal::Types::SetType.new(...)
	end

	# Ensures a value matches the given shape of a Hash
	def _Shape(...)
		Literal::Types::ShapeType.new(...)
	end

	# Matches if the value is a `String` and matches the given constraints.
	# If you don't need any constraints, use `String` instead of `_String`.
	def _String(...)
		Literal::Types::StringType.new(...)
	end

	# Matches if the value is a `Symbol` and matches the given constraint.
	def _Symbol(...)
		Literal::Types::SymbolType.new(...)
	end

	# Matches *"truthy"* values (anything except `nil` and `false`).
	def _Truthy
		Literal::Types::TruthyType
	end

	# Matches if the value is an `Array` and each element matches the given types in order.
	def _Tuple(...)
		Literal::Types::TupleType.new(...)
	end

	# Matches if *any* given type is matched.
	def _Union(...)
		Literal::Union.new(...)
	end

	def _Void
		Literal::Types::VoidType
	end
end
