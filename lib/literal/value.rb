# frozen_string_literal: true

class Literal::Value
	def self.to_proc
		-> (value) { new(value) }
	end

	def self.[](value)
		new(value)
	end

	# Takes a list of method names and delegates them to the underlying value.
	def self.delegate(*methods)
		methods.each do |method_name|
			class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
				# frozen_string_literal: true

				def #{method_name}(...)
					@value.#{method_name}(...)
				end
			RUBY
		end
	end

	def initialize(value)
		Literal.check(value, __type__)
		@value = value
		freeze
	end

	attr_reader :value

	def inspect
		"#{self.class.name}(#{value.inspect})"
	end

	def ===(other)
		self.class === other && @value == other.value
	end

	alias_method :==, :===

	freeze
end
