# frozen_string_literal: true

test do
	maybe = Literal::Maybe(String).new("Hello, World!")

	expect(maybe.map(Integer, &:length).value) == 13
	expect { maybe.map(String, &:length) }.to_raise Literal::TypeError

	expect(maybe.then(Integer) { |s| Literal::Maybe(Integer).new(s.length) }.value) == 13
	expect { maybe.then(String) { |s| Literal::Maybe(Integer).new(s.length) } }.to_raise Literal::TypeError
end
