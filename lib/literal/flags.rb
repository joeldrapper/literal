# frozen_string_literal: true

class Literal::Flags
	include Enumerable

	def initialize(value = 0, **new_flags)
		if new_flags.length > 0
			flags = self.class.flags

			value = new_flags.reduce(value) do |flag, (key, value)|
				value ? flag | (2 ** flags.fetch(key)) : flag
			end
		end

		@value = value
	end

	attr_reader :value

	class << self
		def define(**flags)
			raise ArgumentError if frozen?
			unique_values = flags.values
			unique_values.uniq!
			raise ArgumentError if unique_values.length != flags.length
			@max = unique_values.max
			@flags = flags.dup.freeze

			flags.each do |name, bit|
				class_eval <<~RUBY, __FILE__, __LINE__ + 1
					# frozen_string_literal: true

					def #{name}=(value)
						raise Literal::TypeError unless true == value || false == value

						if value && @value & (2 ** #{bit}) == 0
							@value |= 2 ** #{bit}
						elsif !value && @value & (2 ** #{bit}) > 0
							@value &= ~(2 ** #{bit})
						end
					end

					def #{name}?
						@value & (2 ** #{bit}) > 0
					end
				RUBY
			end

			freeze
		end

		def to_proc
			proc { |value| new(value) }
		end

		def max
			@max
		end

		def flags
			@flags
		end

		def keys
			@flags.keys
		end

		def bits
			@flags.values
		end

		def bit_length
			(2 ** @max).bit_length
		end

		def bytesize
			(bit_length / 8.0).ceil
		end

		def from_bit_string(bit_string)
			new(
				bit_string.to_i(2),
			)
		end

		def unpack(value, ...)
			new(
				value.unpack1(...),
			)
		end
	end

	def inspect
		to_h.inspect
	end

	def to_h
		self.class.flags.transform_values do |bit|
			@value & (2 ** bit) > 0
		end
	end

	def each
		self.class.flags.each do |key, bit|
			yield key, @value & (2 ** bit) > 0
		end
	end

	def [](key)
		@value & (2 ** self.class.flags[key]) > 0
	end

	def []=(key, value)
		raise Literal::TypeError unless true == value || false == value
		bit = self.class.flags[key]

		if value && @value & (2 ** bit) == 0
			@value |= 2 ** bit
		elsif !value && @value & (2 ** bit) > 0
			@value &= ~(2 ** bit)
		end
	end

	def |(other)
		case other
		when Literal::Flags
			self.class.new(@value | other.value)
		when Integer
			self.class.new(@value | other)
		end
	end

	def &(other)
		case other
		when Literal::Flags
			self.class.new(@value & other.value)
		when Integer
			self.class.new(@value & other)
		end
	end

	def merge(other)
		dup.merge!(other)
	end

	def merge!(other)
		other.each { |k, v| self[k] = v }
	end

	def to_i
		@value
	end

	def to_bit_string(bits = nil)
		bits ||= self.class.bytesize * 8
		@value.to_s(2).rjust(bits, "0")
	end

	def pack(...)
		[@value].pack(...)
	end

	def to_a
		buffer = []

		i, length = 0, self.class.max
		while i <= length
			buffer << (@value & (2 ** i) > 0)
			i += 1
		end

		buffer
	end

	alias_method :deconstruct, :to_a

	def deconstruct_keys(keys = nil)
		if keys
			flags = self.class.flags
			keys.to_h do |key|
				[key, @value & (2 ** flags.fetch(key)) > 0]
			end
		else
			to_h
		end
	end
end
