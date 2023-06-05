# frozen_string_literal: true

# @api private
class Literal::Generic < Literal::Type
	abstract!

	abstract :new
end
