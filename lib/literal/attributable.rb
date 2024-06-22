# frozen_string_literal: true

module Literal::Attributable
	autoload :Generators, "literal/attributable/generators"
	autoload :Nodes, "literal/attributable/nodes"
	autoload :Formatter, "literal/attributable/formatter"

	include Literal::Types

	VisibilityOptions = Set[false, :private, :protected, :public].freeze
	KindOptions = Set[nil, :positional, :*, :**, :&].freeze

	def attribute(name, type, kind = nil, reader: false, writer: false, default: nil, &coercion)
		if default && !(Proc === default || default.frozen?)
			raise Literal::ArgumentError.new("The default must be a frozen object or a Proc.")
		end

		unless VisibilityOptions.include?(reader)
			raise Literal::ArgumentError.new("The reader must be one of #{VisibilityOptions.map(&:inspect).join(', ')}.")
		end

		unless VisibilityOptions.include?(writer)
			raise Literal::ArgumentError.new("The writer must be one of #{VisibilityOptions.map(&:inspect).join(', ')}.")
		end

		if reader && :class == name
			raise Literal::ArgumentError.new(
				"The `:class` attribute should not be defined as a reader because it breaks Ruby's `Object#class` method, which Literal itself depends on.",
			)
		end

		unless KindOptions.include?(kind)
			raise Literal::ArgumentError.new("The kind must be one of #{KindOptions.map(&:inspect).join(', ')}.")
		end

		attribute = Literal::Attribute.new(
			name:,
			type:,
			kind:,
			reader:,
			writer:,
			default:,
			coercion:,
		)

		literal_attributes[name] = attribute
		define_literal_methods(attribute)
		include literal_extension
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
			@literal_attributes = Literal::ConcurrentHash.new
		end
	end

	def define_literal_methods(attribute)
		literal_extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
			# frozen_string_literal: true

			#{generate_literal_initializer}

			#{generate_literal_reader(attribute) if attribute.reader}

			#{generate_literal_writer(attribute) if attribute.writer}
		RUBY
	end

	def literal_extension
		defined?(@literal_extension) ? @literal_extension : @literal_extension = Module.new
	end
end
