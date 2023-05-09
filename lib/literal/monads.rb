# frozen_string_literal: true

module Literal::Monads
	Nothing = Literal::Nothing
	Left = Literal::Left
	Right = Literal::Right
	Some = Literal::Some
	Maybe = Literal::Maybe
	Either = Literal::Either
	Result = Literal::Result

	def Maybe(type)
		Literal::MaybeType.new(type)
	end

	def Either(left_type, right_type)
		Literal::EitherType.new(left_type, right_type)
	end

	def Result(type)
		Literal::ResultType.new(type)
	end

	def Try(type, &block)
		Literal::ResultType.new(type).try(&block)
	end

	def Some(type)
		Literal::SomeType.new(type)
	end

	def Left(type)
		Literal::LeftType.new(type)
	end

	def Right(type)
		Literal::RightType.new(type)
	end
end
