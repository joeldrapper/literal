# frozen_string_literal: true

Performance.group "Struct" do
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

		test "Literal" do
			LiteralStruct.new(first_name:, last_name:, age:)
		end
	end

	report "#marshal_dump" do
		baseline "Ruby" do
			Marshal.dump(NormalClass.new(first_name:, last_name:, age:))
		end

		baseline "Dry" do
			Marshal.dump(DryClass.new(first_name:, last_name:, age:))
		end

		baseline "Data" do
			Marshal.dump(NormalData.new(first_name:, last_name:, age:))
		end

		test "Literal" do
			Marshal.dump(LiteralStruct.new(first_name:, last_name:, age:))
		end
	end
end
