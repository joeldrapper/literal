# frozen_string_literal: true

module Literal::Monads
	Nothing = Literal::Nothing.new
	Optional = Nothing # `Maybe` called without anything, e.g. `Maybe(something)` is Nothing

	def Some(thing)
		Literal::Some.new(thing)
	end

	def Optional(value)
		value.nil? ? Nothing : Some(value)
	end

	def Either(left_type, right_type)
		Literal::Either.new(left_type, right_type)
	end

	def Left(value)
		Literal::Left.new(value)
	end

	def Right(value)
		Literal::Right.new(value)
	end

	def Result(type)
		Literal::Result.new(type)
	end

	def Try(type, &)
		Literal::Result.new(type).try(&)
	end
end
