# frozen_string_literal: true

class Foo
	extend Literal::Modifiers
	extend Literal::Memoization
	memoize def bar(key)
		if key == 1
			nil
		else
			SecureRandom.hex(16)
		end
	end
end

foo = Foo.new

# binding.irb
