# frozen_string_literal: true

class Literal::Attribute
	def initialize(name:, type:, special:, reader:, writer:, positional:)
		@name = name
		@type = type
		@special = special
		@reader = reader
		@writer = writer
		@positional = positional
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
				@type === nil ? "#{@name} = nil" : @name
			else
				@type === nil ? "#{@name}: nil" : "#{@name}:"
			end
		end
	end

	def type_check(value = @name) = <<~RUBY
		unless @literal_types[:#{@name}] === #{value}
			raise Literal::TypeError.expected(#{value}, to_be_a: @literal_types[:#{@name}])
		end
	RUBY

	def ivar_assignment = "@#{@name} = #{@name}"
	def mapping = "#{@name}: #{@name}"

	def ivar_writer = <<~RUBY
		def #{@name}=(value)
			#{type_check(:value)}
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
			#{type_check(:value)}
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
