# frozen_string_literal: true

class Literal::Railtie < Rails::Railtie
	initializer "literal.register_literal_enum_type" do
		ActiveRecord::Type.register(:literal_enum) do |name, type:|
			Literal::Rails::EnumType.new(type)
		end

		ActiveRecord::Type.register(:literal_flags) do |name, type:|
			Literal::Rails::FlagsType.new(type)
		end

		ActiveModel::Type.register(:literal_enum) do |name, type:|
			Literal::Rails::EnumType.new(type)
		end

		ActiveModel::Type.register(:literal_flags) do |name, type:|
			Literal::Rails::FlagsType.new(type)
		end
	end
end
