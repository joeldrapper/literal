# frozen_string_literal: true

UserID = Literal::Brand(String)

test do
	string = "123"

	refute UserID === string

	UserID.new(string)

	assert UserID === string
end
