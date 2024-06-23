# frozen_string_literal: true

TracePoint.trace(:end) do |tp|
	it = tp.self

	if Class === it && it < Literal::Enum
		it.__after_defined__
	end
end

class Literal::Enum
	extend Literal::Types

	class << self
		include Enumerable

		attr_reader :members

		def values = @values.keys

		def respond_to_missing?(name, include_private = false)
			return super if frozen?
			return super unless Symbol === name
			return super unless ("A".."Z").include? name[0]

			true
		end

		def inherited(subclass)
			type = @type

			subclass.instance_exec do
				@values = {}
				@members = Set[]
				@type = type
			end
		end

		def _load(data)
			self[Marshal.load(data)]
		end

		def method_missing(name, value, *args, **kwargs, &)
			return super if frozen?
			return super unless name.is_a?(Symbol)
			return super unless name[0] == name[0].upcase
			return super if args.length > 0
			return super if kwargs.length > 0

			raise ArgumentError if @values.key? value
			raise ArgumentError if constants.include?(name)

			value = value.dup.freeze unless value.frozen?

			Literal.check(value, @type)

			member = new(name, value, &)
			const_set name, member
			@values[value] = member
			@members << member

			define_method("#{name.to_s.gsub(/([^A-Z])([A-Z]+)/, '\1_\2').downcase}?") { self == member }
		end

		def __after_defined__
			raise ArgumentError if frozen?

			@values.freeze
			@members.freeze
			freeze
		end

		def each(&)
			@members.each(&)
		end

		def each_value(&)
			@values.each_key(&)
		end

		def [](value)
			@values[value]
		end

		alias_method :cast, :[]

		def to_proc
			method(:cast).to_proc
		end
	end

	def initialize(name, value, &block)
		@name = name
		@value = value
		instance_exec(&block) if block
		freeze
	end

	attr_reader :value

	def name
		"#{self.class.name}::#{@name}"
	end

	alias_method :inspect, :name

	def _dump(level)
		Marshal.dump(@value)
	end
end
