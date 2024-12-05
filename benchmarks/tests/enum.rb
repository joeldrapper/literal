# frozen_string_literal: true

Awfy.group "Enum" do
	report "Fetch" do
		control "Ruby::Enum" do
			RubyEnumColor::RED
		end

		control "TypesafeEnum" do
			TypesafeEnumColor::RED
		end

		test "Literal" do
			LiteralColor::Red
		end
	end

	report "value" do
		control "Ruby::Enum" do
			RubyEnumColor.value(:RED)
		end

		control "TypesafeEnum" do
			TypesafeEnumColor.find_by_value("#FF0000")
		end

		test "Literal" do
			LiteralColor[1]
		end
	end

	report "indexed" do
		control "Ruby::Enum" do
			RubyEnumColor.key("#FF0000")
		end

		control "TypesafeEnum" do
			TypesafeEnumColor.find_by_value("#FF0000")
		end

		test "Literal" do
			LiteralColor.find_by(hex: "#FF0000")
		end
	end

	report ".map" do
		control "Ruby::Enum" do
			RubyEnumColor.map(&:itself)
		end

		control "TypesafeEnum" do
			TypesafeEnumColor.map(&:itself)
		end

		test "Literal" do
			LiteralColor.map(&:itself)
		end
	end

	report "#==" do
		control "Ruby::Enum" do
			RubyEnumColor::RED == RubyEnumColor::RED
		end

		control "TypesafeEnum" do
			TypesafeEnumColor::RED == TypesafeEnumColor::RED
		end

		test "Literal" do
			LiteralColor::Red == LiteralColor::Red
		end
	end

	report ".to_h" do
		control "Ruby::Enum" do
			RubyEnumColor.to_h
		end

		control "TypesafeEnum" do
			TypesafeEnumColor.to_a
		end

		test "Literal" do
			LiteralColor.to_h
		end
	end

	report ".cast" do
		control "Ruby::Enum" do
			RubyEnumColor.value(:RED)
		end

		control "TypesafeEnum" do
			TypesafeEnumColor.find_by_value("#FF0000")
		end

		test "Literal" do
			LiteralColor.cast(1)
		end
	end
end
