# frozen_string_literal: true

Literal::Types::NilableType = Literal::Types::UnionType.new(
	Literal::Types::AnyType,
	nil
)
