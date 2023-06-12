# frozen_string_literal: true

module Literal::Attributes
	include Literal::Types

	def attribute(name, type, special = nil, reader: false, writer: false, positional: false)
		attribute = Literal::Attribute.new(name:, type:, special:, reader:, writer:, positional:)

		literal_types[name] = type
		literal_attributes << attribute

		include literal_extension

		define_literal_initializer
		define_literal_writer(attribute) if writer
		define_literal_reader(attribute) if reader
	end

	def literal_attributes
		return @literal_attributes if defined?(@literal_attributes)

		if superclass.is_a?(Literal::Attributes)
			@literal_attributes = superclass.literal_attributes.dup
		else
			@literal_attributes = Concurrent::Array.new
		end
	end

	def literal_types
		return @literal_types if defined?(@literal_types)

		if superclass.is_a?(Literal::Attributes)
			@literal_types = superclass.literal_types.dup
		else
			@literal_types = Concurrent::Map.new
		end
	end

	private

	def define_literal_initializer
		literal_extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
			# frozen_string_literal: true

			#{literal_initializer}
		RUBY
	end

	def define_literal_writer(attribute)
		literal_extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
			# frozen_string_literal: true

			#{literal_writer(attribute)}
		RUBY
	end

	def define_literal_reader(attribute)
		literal_extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
			# frozen_string_literal: true

			#{literal_reader(attribute)}
		RUBY
	end

	def literal_initializer = <<~RUBY
		def initialize(#{literal_attributes.map(&:param).compact.join(', ')})
			@literal_types = self.class.literal_types
			#{literal_attributes.map(&:type_check).compact.join(';') if Literal::TYPE_CHECKS}
			#{literal_initializer_body}
		end
	RUBY

	def literal_writer(attribute) = attribute.ivar_writer
	def literal_reader(attribute) = attribute.ivar_reader

	def literal_initializer_body
		literal_attributes.map(&:ivar_assignment).compact.join(";")
	end

	def literal_extension
		@literal_extension ||= Module.new
	end
end
