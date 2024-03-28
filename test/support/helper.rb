# frozen_string_literal: true

require "literal"

Zeitwerk::Loader.eager_load_all

class ExampleStruct < Literal::Struct
	attribute :name, String
end

class ExampleData < Literal::Data
	attribute :name, String
end

class ExampleDataEnum < Literal::DataEnum
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
