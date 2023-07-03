# frozen_string_literal: true

class Literal::Attribute
	RUBY_KEYWORDS = %i[alias and begin break case class def do else elsif end ensure false for if in module next nil not or redo rescue retry return self super then true undef unless until when while yield].to_h { |k| [k, "___#{k}___"] }.freeze

	def initialize(name:, type:, special:, reader:, writer:, positional:, default:, coercion:)
		@name = name
		@type = type
		@special = special
		@reader = reader
		@writer = writer
		@positional = positional
		@default = default
		@coercion = coercion
	end

	attr_reader :type, :coercion

	def default?
		nil != @default
	end

	def default_value(context)
		case @default
		when Proc
			context.instance_exec(&@default)
		else
			@default
		end
	end

	def param
		case @special
		when :*
			"*#{@name}"
		when :**
			"**#{@name}"
		when :&
			"&#{@name}"
		else
			if @positional
				if default?
					"#{@name} = Literal::Null"
				else
					@type === nil ? "#{@name} = nil" : @name
				end
			elsif default?
				"#{@name}: Literal::Null"
			else
				@type === nil ? "#{@name}: nil" : "#{@name}:"
			end
		end
	end

	def type_check(value = escaped_name) = <<~RUBY
		unless @literal_attributes[:#{@name}].type === #{value}
		raise Literal::TypeError.expected(#{value}, to_be_a: @literal_attributes[:#{@name}].type)
		end
	RUBY

	def default_assignment
		return if nil == @default

		<<~RUBY
			if Literal::Null == #{escaped_name}
			#{escaped_name} = @literal_attributes[:#{@name}].default_value(self)
			end
		RUBY
	end

	def ivar_assignment = "@#{@name} = #{escaped_name}"
	def mapping = "#{@name}: #{escaped_name}"
	def data_mapping = "#{@name}: #{escaped_name}.frozen? ? #{escaped_name} : #{escaped_name}.dup.tap(&:freeze)"

	def ivar_writer = <<~RUBY
		def #{@name}=(value)
			#{coerce(:value)}
			#{type_check(:value) if Literal::TYPE_CHECKS}
			@#{@name} = value
		end

		#{visibility(@writer)} :#{@name}=
	RUBY

	def ivar_reader = <<~RUBY
		attr_reader :#{@name}

		#{visibility(@reader)} :#{@name}
	RUBY

	def struct_writer = <<~RUBY
		def #{@name}=(value)
			#{coerce(:value)}
			#{type_check(:value) if Literal::TYPE_CHECKS}
			@attributes[:#{@name}] = value
		end

		#{visibility(@writer)} :#{@name}=
	RUBY

	def struct_reader = <<~RUBY
		def #{@name}
			@attributes[:#{@name}]
		end

		#{visibility(@reader)} :#{@name}
	RUBY

	def escape_keywords
		if (escaped = RUBY_KEYWORDS[@name])
			"#{escaped} = binding.local_variable_get(:#{@name})"
		end
	end

	def coerce(name = escaped_name)
		return unless @coercion

		"#{name} = @literal_attributes[:#{@name}].coercion.call(#{name})"
	end

	def escaped_name
		RUBY_KEYWORDS[@name] || @name
	end

	def visibility(value)
		case value
		when :public, :private, :protected
			value
		else
			:private
		end
	end
end
