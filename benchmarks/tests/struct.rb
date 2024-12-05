# frozen_string_literal: true

Awfy.group "Struct" do
	first_name = "Joel"
	last_name = "Drapper"
	age = 29

	report ".new" do
		control "Ruby Struct" do
			NormalStruct.new(first_name:, last_name:, age:)
		end

		control "Dry::Struct" do
			DryStruct.new(first_name:, last_name:, age:)
		end

		control "Ruby Data" do
			NormalData.new(first_name:, last_name:, age:)
		end

		control "ActiveModel::Attributes" do
			ActiveModelAttributesClass.new(first_name:, last_name:, age:)
		end

		test "Literal::Struct" do
			LiteralStruct.new(first_name:, last_name:, age:)
		end
	end

	report "#marshal_dump" do
		normal_class = NormalClass.new(first_name:, last_name:, age:)
		dry_class = DryClass.new(first_name:, last_name:, age:)
		normal_data = NormalData.new(first_name:, last_name:, age:)
		active_model = ActiveModelAttributesClass.new(first_name:, last_name:, age:)
		literal = LiteralStruct.new(first_name:, last_name:, age:)

		control "Ruby" do
			Marshal.dump(normal_class)
		end

		control "Dry" do
			Marshal.dump(dry_class)
		end

		control "Data" do
			Marshal.dump(normal_data)
		end

		control "ActiveModel" do
			Marshal.dump(active_model)
		end

		test "Literal" do
			Marshal.dump(literal)
		end
	end
end
