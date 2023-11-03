# frozen_string_literal: true

class Literal::Enum
	class << self
		attr_reader :type
		attr_reader :members

		def values = @values.keys

		def respond_to_missing?(name)
			return super if frozen?
			return super unless Symbol === name
			return super unless name[0] =~ /[A-Z]/

			true
		end

		def method_missing(name, value, *args, **kwargs, &)
			return super if frozen?
			return super unless name.is_a?(Symbol)
			return super unless name[0] == name[0].upcase

			raise ArgumentError if args.length > 0
			raise ArgumentError if kwargs.length > 0
			raise ArgumentError if @values.key? value
			raise ArgumentError if constants.include?(name)

			unless @type === value
				raise Literal::TypeError.expected(value, to_be_a: @type)
			end

			value = value.dup.freeze unless value.frozen?

			member = new(name, value)
			const_set name, member
			@values[value] = member
			@members << member

			define_method("#{name.to_s.downcase.gsub(/(?<=[A-Z])(?=[A-Z][a-z])|(?<=[a-z\d])(?=[A-Z])/, '_')}?") { self == member }
		end

		def deep_freeze
			@values.freeze
			@members.freeze
			freeze
		end
	end

	def initialize(name, value)
		@name = name
		@value = value
		freeze
	end

	attr_reader :value

	def name
		"#{self.class.name}::#{@name}"
	end

	alias_method :inspect, :name
end
