# frozen_string_literal: true

Awfy.group "Properties" do
	report ".prop" do
		example_class = Class.new do
			extend Literal::Properties
		end

		control "simple property" do
			example_class.prop(:name, String)
		end

		test "property with public reader" do
			example_class.prop(:name, String, reader: :public)
		end

		test "property with all options" do
			example_class.prop(
				:name,
				String,
				:keyword,
				reader: :public,
				writer: :public,
				predicate: :public
			)
		end

		default = "default"
		test "property with default" do
			example_class.prop(:name, String, default:)
		end

		test "property with default and reader" do
			example_class.prop(:name, String, default:, reader: :public)
		end

		test "property with coercion" do
			example_class.prop(:name, String, &:to_s)
		end
	end

	report ".literal_properties" do
		base_class = Class.new do
			extend Literal::Properties
			prop :name, String
		end

		child_class = Class.new(base_class) do
			prop :age, Integer
		end

		control "base" do
			base_class.literal_properties
		end

		test "inherited" do
			child_class.literal_properties
		end
	end

	first_name = "test"
	last_name = "user"
	age = 30

	report "object instantiation" do
		control "Hash" do
			{ first_name:, last_name:, age: }
		end

		control "Ruby" do
			NormalClass.new(first_name: name, last_name: name, age:)
		end

		control "Dry" do
			DryClass.new(first_name: name, last_name: name, age:)
		end

		control "ActiveModel" do
			ActiveModelAttributesClass.new(first_name:, last_name:, age:)
		end

		test "Literal" do
			LiteralClass.new(first_name: name, last_name:, age:)
		end
	end

	hash_instance = { first_name:, last_name:, age: }
	literal_instance = LiteralClassWithReaders.new(first_name: name, last_name:, age:)
	dry_instance = DryClass.new(first_name: name, last_name: name, age:)
	normal_instance = NormalClass.new(first_name: name, last_name: name, age:)
	active_model_instance = ActiveModelAttributesClass.new(first_name:, last_name:, age:)

	report "public property access" do
		control "Hash" do
			hash_instance[:first_name]
		end

		control "Ruby" do
			normal_instance.first_name
		end

		control "Dry" do
			dry_instance.first_name
		end

		control "ActiveModel" do
			active_model_instance.first_name
		end

		test "Literal" do
			literal_instance.first_name
		end
	end
end
