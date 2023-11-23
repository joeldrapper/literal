# frozen_string_literal: true

class Error < Literal::DataEnum
	attribute :name, String
	attribute :message, String

	index :name, String, unique: true

	define(
		name: "Connection Error",
		message: "There was a problem connecting to the server."
	)

	define(
		name: "Authentication Error",
		message: "There was a problem authenticating with the server."
	)
end

test do
	assert Error.frozen?
	assert Error[0].frozen?

	expect(
		Error.find_by(name: "Connection Error")
	) == Error[0]

	expect(
		Error.where(name: "Connection Error")
	) == [Error[0]]
end
