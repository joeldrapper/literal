# frozen_string_literal: true

test do
	expect(Literal::Null.inspect) == "Literal::Null"
	assert Literal::Null.frozen?
end
