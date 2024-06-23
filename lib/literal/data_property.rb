# frozen_string_literal: true

class Literal::DataProperty < Literal::Property
	def generate_initializer_assign_value
		"#{ivar_ref} = #{local_var_ref}.frozen? ? #{local_var_ref} : #{local_var_ref}.dup.freeze"
	end
end
