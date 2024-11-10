# frozen_string_literal: true

class Literal::Object
	module BlankInitializerForRubyMine
		def initialize(*a, **k, &b)
			nil
		end
	end

	prepend BlankInitializerForRubyMine

	extend Literal::Properties
end
