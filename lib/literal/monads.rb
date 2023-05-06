# frozen_string_literal: true

module Literal::Monads
	Nothing = Literal::Nothing.new
	Maybe = Nothing # `Maybe` called without anything, e.g. `Maybe(something)` is Nothing

	def Something(thing)
		Literal::Something.new(thing)
	end

	def Maybe(value = nil)
		value.nil? ? NOTHING : Something(value)
	end

	def Either(whatever)

	end
end
