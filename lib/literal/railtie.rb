# frozen_string_literal: true

class Literal::Railtie < Rails::Railtie
	initializer "literal.register_literal_enum_type" do
		[ActiveRecord::Type, ActiveModel::Type].each do |registry|
			registry.register(:literal_enum) do |name, type:|
				Literal::Rails::EnumType.new(type)
			end

			registry.register(:literal_flags) do |name, type:|
				Literal::Rails::FlagsType.new(type)
			end
		end
	end
end
