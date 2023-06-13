# frozen_string_literal: true

class Literal::Attribute
	def initialize(name:, type:, special:, reader:, writer:, positional:, default:)
		@name = name
		@type = type
		@special = special
		@reader = reader
		@writer = writer
		@positional = positional
		@default = default
	end

	attr_reader :type

	def default_value
		case @default
		when Proc
			@default.call
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
				if @default
					"#{@name} = Literal::Null"
				else
					@type === nil ? "#{@name} = nil" : @name
				end
			elsif @default
				"#{@name}: Literal::Null"
			else
				@type === nil ? "#{@name}: nil" : "#{@name}:"
			end
		end
	end

	def type_check(value = @name) = <<~RUBY
		unless @literal_attributes[:#{@name}].type === #{value}
		raise Literal::TypeError.expected(#{value}, to_be_a: @literal_attributes[:#{@name}].type)
		end
	RUBY

	def default_assignment
		return unless @default

		<<~RUBY
			if Literal::Null == #{@name}
				#{@name} = @literal_attributes[:#{@name}].default_value
			end
		RUBY
	end

	def ivar_assignment = "@#{@name} = #{@name}"
	def mapping = "#{@name}: #{@name}"

	def ivar_writer = <<~RUBY
		def #{@name}=(value)
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

	def visibility(value)
		case value
		when :public, :private, :protected
			value
		else
			:private
		end
	end
end
