# frozen_string_literal: true

Awfy.group "Data" do
	shared_values = {
		first_name: "Joel",
		last_name: "Drapper",
		age: 29,
	}

	report ".new" do
		control "Ruby Struct" do
			NormalStruct.new(**shared_values)
		end

		control "Dry" do
			DryStruct.new(**shared_values)
		end

		control "Ruby Data" do
			NormalData.new(**shared_values)
		end

		test "Literal Data" do
			LiteralData.new(**shared_values)
		end
	end

	# Pre-create objects for property access tests
	normal_struct = NormalStruct.new(**shared_values)
	dry_struct = DryStruct.new(**shared_values)
	normal_data = NormalData.new(**shared_values)
	literal_data = LiteralData.new(**shared_values)

	report "property access" do
		control "Ruby Struct" do
			normal_struct.first_name
			normal_struct.last_name
			normal_struct.age
		end

		control "Dry" do
			dry_struct.first_name
			dry_struct.last_name
			dry_struct.age
		end

		control "Ruby Data" do
			normal_data.first_name
			normal_data.last_name
			normal_data.age
		end

		test "Literal Data" do
			literal_data.first_name
			literal_data.last_name
			literal_data.age
		end
	end

	report "#==" do
		# Create second set of objects for equality comparison
		normal_struct2 = NormalStruct.new(**shared_values)
		dry_struct2 = DryStruct.new(**shared_values)
		normal_data2 = NormalData.new(**shared_values)
		literal_data2 = LiteralData.new(**shared_values)

		control "Ruby Struct" do
			normal_struct == normal_struct2
		end

		control "Dry" do
			dry_struct == dry_struct2
		end

		control "Ruby Data" do
			normal_data == normal_data2
		end

		test "Literal Data" do
			literal_data == literal_data2
		end
	end

	report "#to_h" do
		control "Ruby Struct" do
			normal_struct.to_h
		end

		control "Dry" do
			dry_struct.to_h
		end

		control "Ruby Data" do
			normal_data.to_h
		end

		test "Literal Data" do
			literal_data.to_h
		end
	end

	report "#hash" do
		control "Ruby Struct" do
			normal_struct.hash
		end

		control "Dry" do
			dry_struct.hash
		end

		control "Ruby Data" do
			normal_data.hash
		end

		test "Literal Data" do
			literal_data.hash
		end
	end

	report "#deconstruct" do
		control "Ruby Struct" do
			normal_struct.deconstruct
		end

		control "Ruby Data" do
			normal_data.deconstruct
		end

		test "Literal Data" do
			literal_data.deconstruct
		end
	end

	report "#deconstruct_keys" do
		keys = [:first_name, :last_name, :age]

		control "Ruby Struct" do
			normal_struct.deconstruct_keys(keys)
		end

		control "Dry" do
			dry_struct.deconstruct_keys(keys)
		end

		control "Ruby Data" do
			normal_data.deconstruct_keys(keys)
		end

		test "Literal Data" do
			literal_data.deconstruct_keys(keys)
		end
	end
end
