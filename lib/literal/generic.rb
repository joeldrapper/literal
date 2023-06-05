# frozen_string_literal: true

class Literal::Generic < Literal::Type
	abstract!

	abstract def new = nil
end
