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
	autoload :SymbolType, "literal/types/symbol_type"
	autoload :TruthyType, "literal/types/truthy_type"
	autoload :TupleType, "literal/types/tuple_type"
	autoload :UnionType, "literal/types/union_type"
	autoload :VoidType, "literal/types/void_type"

	NilableBooleanType = NilableType.new(BooleanType::Instance).freeze
	NilableCallableType = NilableType.new(CallableType::Instance).freeze
	NilableJSONDataType = NilableType.new(JSONDataType).freeze
	NilableLambdaType = NilableType.new(LambdaType).freeze
	NilableProcableType = NilableType.new(ProcableType).freeze

	# Matches any value except `nil`. Use `_Any?` or `_Void` to match any value including `nil`.
	def _Any
		AnyType::Instance
	end

	def _Any?
		VoidType
	end

	# Matches if the value is an `Array` and all the elements match the given type.
	def _Array(...)
		ArrayType.new(...)
	end

	# Nilable version of `_Array`
	def _Array?(...)
		NilableType.new(
			ArrayType.new(...)
		)
	end

	# Matches if the value is `true` or `false`.
	def _Boolean
		BooleanType::Instance
	end

	# Nilable version of `_Boolean`
	def _Boolean?
		NilableBooleanType
	end

	# Matches if the value responds to `#call`.
	def _Callable
		CallableType::Instance
	end

	# Nilabl version of `_Callable`
	def _Callable?
		NilableCallableType
	end

	# Matches if the value either the given class or a subclass of it.
	def _Class(...)
		ClassType.new(...)
	end

	# Nilable version of `_Class`
	def _Class?(...)
		NilableType.new(
			ClassType.new(...)
		)
	end

	# Similar to `_Intersection`, but allows you to specify attribute constraints as keyword arguments.
	# @example
	# 	_Constraint(Array, size: 1..3)
	def _Constraint(...)
		ConstraintType.new(...)
	end

	# Nilable version of `_Constraint`
	def _Constraint?(...)
		NilableType.new(
			ConstraintType.new(...)
		)
	end

	# Matches if the value is a descendant of the given class.
	def _Descendant(...)
		DescendantType.new(...)
	end

	# Nilable version of `_Descendant`
	def _Descendant?(...)
		NilableType.new(
			DescendantType.new(...)
		)
	end

	#  Matches if the value is an `Enumerable` and all its elements match the given type.
	def _Enumerable(...)
		EnumerableType.new(...)
	end

	# Nilable version of `_Enumerable`
	def _Enumerable?(...)
		NilableType.new(
			EnumerableType.new(...)
		)
	end

	# Matches *"falsy"* values (`nil` and `false`).
	def _Falsy
		FalsyType::Instance
	end

	# Matches if the value is a `Float` and matches the given constraints.
	# You could use a `Range`, for example, as a constraint.
	# If you don't need a constraint, use `Float` instead of `_Float`.
	def _Float(...)
		_Constraint(Float, ...)
	end

	# Nilable version of `_Float`
	def _Float?(...)
		_Nilable(
			_Float(...)
		)
	end

	# Matches if the value is *frozen*.
	def _Frozen(...)
		FrozenType.new(...)
	end

	# Nilable version of `_Frozen`
	def _Frozen?(...)
		NilableType.new(
			FrozenType.new(...)
		)
	end

	# Matches if the value is a `Hash` and all the keys and values match the given types.
	def _Hash(...)
		HashType.new(...)
	end

	# Nilable version of `_Hash`
	def _Hash?(...)
		NilableType.new(
			HashType.new(...)
		)
	end

	# Matches if the value is an `Integer` and matches the given constraint.
	# You could use a `Range`, for example, as a constraint.
	# If you don't need a constraint, use `Integer` instead of `_Integer`.
	# @example
	# 	attribute :age, _Integer(18..127)
	def _Integer(...)
		IntegerType.new(...)
	end

	# Nilable version of `_Integer`
	def _Integer?(...)
		NilableType.new(
			IntegerType.new(...)
		)
	end

	# Matches if the value responds to all the given methods.
	def _Interface(...)
		InterfaceType.new(...)
	end

	# Nilable version of `_Interface`
	def _Interface?(...)
		NilableType.new(
			InterfaceType.new(...)
		)
	end

	# Matches if *all* given types are matched.
	def _Intersection(...)
		IntersectionType.new(...)
	end

	# Nilable version of `_Intersection`
	def _Intersection?(...)
		NilableType.new(
			IntersectionType.new(...)
		)
	end

	# Ensures the value is valid JSON data (i.e. it came from JSON.parse).
	def _JSONData
		JSONDataType
	end

	# Nilable version of `_JSONData`
	def _JSONData?
		NilableJSONDataType
	end

	# Matches if the value is a `Proc` and `#lambda?` returns truthy.
	def _Lambda
		LambdaType
	end

	# Nilable version of `_Lambda`
	def _Lambda?
		NilableLambdaType
	end

	def _Map(...)
		MapType.new(...)
	end

	# Nilable version of `_Map`
	def _Map?(...)
		NilableType.new(
			MapType.new(...)
		)
	end

	# Never matches any value.
	def _Never
		NeverType
	end

	# Matches if the value is either `nil` or the given type.
	def _Nilable(...)
		NilableType.new(...)
	end

	# Matches if the given type is *not* matched.
	def _Not(...)
		NotType.new(...)
	end

	# Matches if the value is a `Proc` or responds to `#to_proc`.
	def _Procable
		ProcableType
	end

	# Nilable version ofo `_Procable`
	def _Procable?
		NilableProcableType
	end

	# Matches if the value is a `Range` of the given type.
	def _Range(...)
		RangeType.new(...)
	end

	# Nilable version of `_Range`
	def _Range?(...)
		NilableType.new(
			RangeType.new(...)
		)
	end

	# Matches if the value is a `Set` and all the elements match the given type.
	def _Set(...)
		SetType.new(...)
	end

	# Nilable version of `_Set`
	def _Set?(...)
		NilableType.new(
			SetType.new(...)
		)
	end

	# Matches if the value is a `String` and matches the given constraints.
	# If you don't need any constraints, use `String` instead of `_String`.
	def _String(...)
		_Constraint(String, ...)
	end

	# Nilable version of `_String`
	def _String?(...)
		_Nilable(
			_String(...)
		)
	end

	# Matches if the value is a `Symbol` and matches the given constraint.
	def _Symbol(...)
		SymbolType.new(...)
	end

	# Nilable version of `_Symbol`
	def _Symbol?(...)
		NilableType.new(
			SymbolType.new(...)
		)
	end

	# Matches *"truthy"* values (anything except `nil` and `false`).
	def _Truthy
		TruthyType
	end

	# Matches if the value is an `Array` and each element matches the given types in order.
	def _Tuple(...)
		TupleType.new(...)
	end

	# Nilable version of `_Typle`
	def _Tuple?(...)
		NilableType.new(
			TupleType.new(...)
		)
	end

	# Matches if *any* given type is matched.
	def _Union(...)
		UnionType.new(...)
	end

	# Nilable version of `_Union`
	def _Union?(...)
		NilableType.new(
			UnionType.new(...)
		)
	end

	def _Void
		VoidType
	end
end
