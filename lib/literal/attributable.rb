# frozen_string_literal: true

module Literal::Attributable
	include Literal::Types

	Visibility = [:private, :protected, :public].freeze

	def attribute(name, type, special = nil, reader: false, writer: false, positional: false, default: nil, &coercion)
		if default && !(Proc === default || default.frozen?)
			raise Literal::ArgumentError, "The `default` must be a frozen value or a Proc."
		end

		unless false == reader || Visibility.include?(reader)
			raise Literal::ArgumentError, "The `reader` must be one of #{Visibility.map(&:inspect).join(', ')}."
		end

		unless false == writer || Visibility.include?(writer)
			raise Literal::ArgumentError, "The `writer` must be one of #{Visibility.map(&:inspect).join(', ')}."
		end

		if special && positional
			raise Literal::ArgumentError, "The #{name} attribute cannot be #{special} and positional."
		end

		if :class == name && reader
			raise Literal::ArgumentError, "The `:class` attribute should not be defined as a reader because it breaks Ruby's `Object#class` method, which Literal itself depends on."
		end

		attribute = Literal::Attribute.new(
			name:,
			type:,
			special:,
			reader:,
			writer:,
			positional:,
			default:,
			coercion:
		)

		literal_attributes[name] = attribute

		include literal_extension

		define_literal_methods(attribute)
	end

	def inherited(subclass)
		literal_attributes = self.literal_attributes

		subclass.instance_exec do
			@literal_attributes = literal_attributes.dup
		end

		super
	end

	def literal_attributes
		return @literal_attributes if defined?(@literal_attributes)

		if superclass.is_a?(Literal::Attributable)
			@literal_attributes = superclass.literal_attributes.dup
		else
			@literal_attributes = Concurrent::Hash.new
		end
	end

	def define_literal_methods(attribute)
		literal_extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
			# frozen_string_literal: true

			#{generate_literal_initializer}

			#{generate_literal_reader(attribute) if attribute.reader?}

			#{generate_literal_writer(attribute) if attribute.writer?}
		RUBY
	end

	def literal_extension
		defined?(@literal_extension) ? @literal_extension : @literal_extension = Module.new
	end
end
