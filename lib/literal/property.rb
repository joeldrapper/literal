# frozen_string_literal: true

class Literal::Property
	ORDER = { :positional => 0, :* => 1, :keyword => 2, :** => 3, :& => 4 }.freeze
	RUBY_KEYWORDS = %i[alias and begin break case class def do else elsif end ensure false for if in module next nil not or redo rescue retry return self super then true undef unless until when while yield].to_h { |k| [k, "__#{k}__"] }.freeze

	VISIBILITY_OPTIONS = Set[false, :private, :protected, :public].freeze
	KIND_OPTIONS = Set[:positional, :*, :keyword, :**, :&].freeze

	include Comparable

	def initialize(name:, type:, kind:, reader:, writer:, default:, coercion:)
		@name = name
		@type = type
		@kind = kind
		@reader = reader
		@writer = writer
		@default = default
		@coercion = coercion
	end

	attr_reader :name, :type, :kind, :reader, :writer, :default, :coercion

	def <=>(other)
		ORDER[@kind] <=> ORDER[other.kind]
	end

	def coerce(value, context:)
		context.instance_exec(value, &@coercion)
	end

	def ruby_keyword?
		!!RUBY_KEYWORDS[@name]
	end

	def escaped_name
		RUBY_KEYWORDS[@name] || @name
	end

	def default_value
		case @default
			when Proc then @default.call
			else @default
		end
	end

	def check(value)
		unless @type === value
			raise Literal::TypeError.expected(value, to_be_a: @type)
		end
	end

	def ivar_ref
		"@#{@name}"
	end

	alias_method :local_var_ref, :escaped_name

	def symbol_ref
		":#{@name}"
	end

	def generate_reader_method
		[
			"#{@reader || :public} ",
			[
				"def #{@name}",
				"value = #{ivar_ref}",
				"@literal_properties[#{symbol_ref}].check(value)",
				"value",
				"end",
			].join("\n"),
		].join
	end

	def generate_writer_method
		[
			"#{writer || :public} ",
			[
				"def #{name}=(value)",
				"@literal_properties[:#{name}].check(value)",
				"@#{name} = value",
				"end",
			].join("\n"),
		].join
	end

	def generate_initializer_handle_property
		[
			"# #{name}",
			(generate_initializer_escape_keyword if (@kind == :keyword) && ruby_keyword?),
			(generate_initializer_coerce_property if @coercion),
			(generate_initializer_assign_default if @default),
			(generate_initializer_check_type),
			(generate_initializer_assign_value),
		].join("\n")
	end

	private

	def generate_initializer_escape_keyword
		"#{escaped_name} = binding.local_variable_get(#{symbol_ref})"
	end

	def generate_initializer_coerce_property
		"#{escaped_name} = @literal_properties[#{symbol_ref}].coerce(#{local_var_ref}, context: self)"
	end

	def generate_initializer_assign_default
		[
			"if Literal::Null == #{local_var_ref}",
			"#{local_var_ref} = @literal_properties[#{symbol_ref}].default_value",
			"end",
		].join("\n")
	end

	def generate_initializer_check_type
		"@literal_properties[:#{name}].check(#{escaped_name})"
	end

	def generate_initializer_assign_value
		"#{ivar_ref} = #{local_var_ref}"
	end
end
