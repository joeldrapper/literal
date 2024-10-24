# frozen_string_literal: true

Awfy.group "Struct" do
	first_name = "Joel"
	last_name = "Drapper"
	age = 29

	report ".new" do
		baseline "Ruby" do
			NormalStruct.new(first_name:, last_name:, age:)
		end

		baseline "Dry" do
			DryStruct.new(first_name:, last_name:, age:)
		end

		baseline "Data" do
			NormalData.new(first_name:, last_name:, age:)
		end

		baseline "ActiveModel" do
			ActiveModelAttributesClass.new(first_name: first_name, last_name: last_name, age: age)
		end

		test "Literal" do
			LiteralStruct.new(first_name:, last_name:, age:)
		end
	end

	report "#marshal_dump" do
		normal_class = NormalClass.new(first_name:, last_name:, age:)
		dry_class = DryClass.new(first_name:, last_name:, age:)
		normal_data = NormalData.new(first_name:, last_name:, age:)
		active_model = ActiveModelAttributesClass.new(first_name: first_name, last_name: last_name, age: age)
		literal = LiteralStruct.new(first_name:, last_name:, age:)

		baseline "Ruby" do
			Marshal.dump(normal_class)
		end

		baseline "Dry" do
			Marshal.dump(dry_class)
		end

		baseline "Data" do
			Marshal.dump(normal_data)
		end

		baseline "ActiveModel" do
			Marshal.dump(active_model)
		end

		test "Literal" do
			Marshal.dump(literal)
		end
	end
end
