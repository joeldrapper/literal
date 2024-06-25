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
		default? || @type === nil
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

	def default?
	  nil != @default
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
		RUBY_KEYWORDS[@name] || @name.name
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

	if Literal::TYPE_CHECKS_DISABLED
		def generate_reader_method(buffer = +"")
			buffer <<
				(@reader ? @reader.name : "public") <<
				" def " <<
				@name.name <<
				"\nvalue = @" <<
				@name.name <<
				"\nvalue\nend\n"
		end
	else # type checks are enabled
		def generate_reader_method(buffer = +"")
			buffer <<
				(@reader ? @reader.name : "public") <<
				" def " <<
				@name.name <<
				"\nvalue = @" <<
				@name.name <<
				"\nself.class.literal_properties[:" <<
				@name.name <<
				"].check(value)\n" <<
				"value\nend\n"
		end
	end

	if Literal::TYPE_CHECKS_DISABLED
		def generate_writer_method(buffer = +"")
			buffer <<
				(@writer ? @writer.name : "public") <<
				" def " <<
				@name.name <<
				"=(value)\n" <<
				"@#{@name.name} = value\nend\n"
		end
	else # type checks are enabled
		def generate_writer_method(buffer = +"")
			buffer <<
				(@writer ? @writer.name : "public") <<
				" def " <<
				@name.name <<
				"=(value)\n" <<
				"self.class.literal_properties[:" <<
				@name.name <<
				"].check(value)\n" <<
				"@#{@name.name} = value\nend\n"
		end
	end

	def generate_initializer_handle_property(buffer = +"")
		buffer << "# " << @name.name << "\n" <<
			"property = properties[:" << @name.name << "]\n"

		if @kind == :keyword && ruby_keyword?
			generate_initializer_escape_keyword(buffer)
		end

		if @coercion
			generate_initializer_coerce_property(buffer)
		end

		if default?
			generate_initializer_assign_default(buffer)
		end

		unless Literal::TYPE_CHECKS_DISABLED
			generate_initializer_check_type(buffer)
		end

		generate_initializer_assign_value(buffer)
	end

	private

	def generate_initializer_escape_keyword(buffer = +"")
		buffer <<
			escaped_name <<
			" = binding.local_variable_get(:" <<
			@name.name <<
			")\n"
	end

	def generate_initializer_coerce_property(buffer = +"")
		buffer <<
			escaped_name <<
			"= property.coerce(" <<
			escaped_name <<
			", context: self)\n"
	end

	def generate_initializer_assign_default(buffer = +"")
		buffer <<
			"if " <<
			((@kind == :&) ? "nil" : "Literal::Null") <<
			" == " <<
			escaped_name <<
			"\n" <<
			escaped_name <<
			" = property.default_value\nend\n"
	end

	def generate_initializer_check_type(buffer = +"")
		buffer <<
			"unless property.type === " << escaped_name << "\n" <<
			"raise Literal::TypeError.expected(" << escaped_name << ", to_be_a: property.type)\n" <<
			"end\n"
	end

	def generate_initializer_assign_value(buffer = +"")
		buffer <<
			"@" <<
			@name.name <<
			" = " <<
			escaped_name <<
			"\n"
	end
end
