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

	def optional?
		@default || @type === nil
	end

	def required?
		!optional?
	end

	def keyword?
		@kind == :keyword
	end

	def positional?
		@kind == :positional
	end

	def splat?
		@kind == :*
	end

	def double_splat?
		@kind == :**
	end

	def block?
		@kind == :&
	end

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
		Literal.check(value, @type)
	end

	def ivar_ref
		"@#{@name}"
	end

	alias_method :local_var_ref, :escaped_name

	def symbol_ref
		":#{@name}"
	end

	if Literal::TYPE_CHECKS_DISABLED
		def generate_reader_method(buffer = +"")
			buffer <<
				(reader ? reader.name : "public") <<
				" def " <<
				name.name <<
				"\nvalue = " <<
				ivar_ref <<
				"\nvalue\nend"
		end
	else # type checks are enabled
		def generate_reader_method(buffer = +"")
			buffer <<
				(reader ? reader.name : "public") <<
				" def " <<
				name.name <<
				"\nvalue = " <<
				ivar_ref <<
				"\n@literal_properties[" <<
				symbol_ref <<
				"].check(value)\n" <<
				"value\nend"
		end
	end

	def generate_writer_method
		[
			"#{writer || :public} ",
			[
				"def #{name}=(value)",
				("@literal_properties[#{symbol_ref}].check(value)" unless Literal::TYPE_CHECKS_DISABLED),
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
			(generate_initializer_check_type unless Literal::TYPE_CHECKS_DISABLED),
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
			"if #{(@kind == :&) ? 'nil' : 'Literal::Null'} == #{local_var_ref}",
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
