# frozen_string_literal: true

class Literal::Formatter < Literal::Visitor
	INDENTATION_CHARACTER = "  "

	def initialize
		@buffer = +""
		@indentation_level = 0
	end

	def text(value)
		case value
		when String
			@buffer << value
		when Symbol
			@buffer << value.name
		else
			@buffer << value.to_s
		end
	end

	def comment(string)
		text "# #{string}"
		newline
	end

	def newline
		@buffer << "\n" << (INDENTATION_CHARACTER * @indentation_level)
	end

	def indent
		@indentation_level += 1
		newline
		yield
		@indentation_level -= 1
	end
end
