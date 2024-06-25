# frozen_string_literal: true

module Literal::Properties
	autoload :Schema, "literal/properties/schema"
	autoload :DataSchema, "literal/properties/data_schema"

	include Literal::Types

	def prop(name, type, kind = :keyword, reader: false, writer: false, default: nil, &coercion)
		if default && !(Proc === default || default.frozen?)
			raise Literal::ArgumentError.new("The default must be a frozen object or a Proc.")
		end

		unless Literal::Property::VISIBILITY_OPTIONS.include?(reader)
			raise Literal::ArgumentError.new("The reader must be one of #{Literal::Property::VISIBILITY_OPTIONS.map(&:inspect).join(', ')}.")
		end

		unless Literal::Property::VISIBILITY_OPTIONS.include?(writer)
			raise Literal::ArgumentError.new("The writer must be one of #{Literal::Property::VISIBILITY_OPTIONS.map(&:inspect).join(', ')}.")
		end

		if reader && :class == name
			raise Literal::ArgumentError.new(
				"The `:class` property should not be defined as a reader because it breaks Ruby's `Object#class` method, which Literal itself depends on.",
			)
		end

		unless Literal::Property::KIND_OPTIONS.include?(kind)
			raise Literal::ArgumentError.new("The kind must be one of #{Literal::Property::KIND_OPTIONS.map(&:inspect).join(', ')}.")
		end

		property = __literal_property_class__.new(
			name:,
			type:,
			kind:,
			reader:,
			writer:,
			default:,
			coercion:,
		)

		literal_properties << property
		__define_literal_methods__(property)
		include(__literal_extension__)
	end

	def literal_properties
		return @literal_properties if defined?(@literal_properties)

		if superclass.is_a?(Literal::Properties)
			@literal_properties = superclass.literal_properties.dup
		else
			@literal_properties = Literal::Properties::Schema.new
		end
	end

	private

	def __literal_property_class__
		Literal::Property
	end

	def __define_literal_methods__(new_property)
		__literal_extension__.module_eval(
			__generate_literal_methods__(new_property),
		)
	end

	def __literal_extension__
		if defined?(@__literal_extension__)
			@__literal_extension__
		else
			@__literal_extension__ = Module.new
		end
	end

	def __generate_literal_methods__(new_property, buffer = +"")
		buffer << "# frozen_string_literal: true\n"
		literal_properties.generate_initializer(buffer)
		literal_properties.generate_to_h(buffer)
		new_property.generate_writer_method(buffer) if new_property.writer
		new_property.generate_reader_method(buffer) if new_property.reader
		buffer
	end
end
