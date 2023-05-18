# frozen_string_literal: true

module Literal::Generic
	include Literal::Type

	abstract!

	abstract def new = nil
end
