# frozen_string_literal: true

module Literal::Attributes
	include Literal::Types

	def attribute(name, type, special = nil, reader: false, writer: false, positional: false, default: nil, &coercion)
		if default && !(Proc === default || default.frozen?)
			raise ArgumentError, "The `default` must be a frozen value or a Proc."
		end

		if :class == name && reader
			raise ArgumentError, "The `:class` attribute should not be defined as a reader because it breaks Ruby's `Object#class` method, which Literal itself depends on."
		end

		attribute = Literal::Attribute.new(name:, type:, special:, reader:, writer:, positional:, default:, coercion:)

		literal_attributes[name] = attribute

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
			@literal_attributes = Concurrent::Hash.new
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
		def initialize(#{literal_attributes.each_value.map(&:param).compact.join(', ')})
			@literal_attributes = self.class.literal_attributes

			# Escape Keywords
			#{literal_attributes.each_value.map(&:escape_keywords).compact.join("\n")}

			# Coercion
			#{literal_attributes.each_value.map(&:coerce).compact.join("\n")}

			# Default Assignment
			#{literal_attributes.each_value.map(&:default_assignment).compact.join("\n")}

			# Type Check
			#{literal_attributes.each_value.map(&:type_check).compact.join("\n") if Literal::TYPE_CHECKS}

			# Initializer Body
			#{literal_initializer_body}
		end
	RUBY

	def literal_writer(attribute) = attribute.ivar_writer
	def literal_reader(attribute) = attribute.ivar_reader

	def literal_initializer_body
		literal_attributes.each_value.map(&:ivar_assignment).compact.join("\n")
	end

	def literal_extension
		@literal_extension ||= Module.new
	end
end
