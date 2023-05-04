# frozen_string_literal: true

module Literal::Initializer
	def initialize(**attributes)
		self.class.__attributes__.each do |name|
			attributes[name] ||= nil
		end

		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end
end
