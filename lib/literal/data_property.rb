# frozen_string_literal: true

class Literal::DataProperty < Literal::Property
	def generate_initializer_assign_value(buffer = +"")
		buffer <<
			"@" <<
			@name.name <<
			" = " <<
			escaped_name <<
			".frozen? ? " <<
			escaped_name <<
			" : " <<
			escaped_name <<
			".freeze\n"
	end
end
