# frozen_string_literal: true

class Literal::LRU
	def initialize(max_size, key_type:, value_type:)
		@hash = {}
		@mutex = Mutex.new
		@max_size = max_size
		@key_type = key_type
		@value_type = value_type

		freeze
	end

	attr_reader :key_type, :value_type

	def [](key)
		@mutex.synchronize do
			if (value = @hash[key])
				@hash.delete(key)
				@hash[key] = value
			end
		end
	end

	def []=(key, value)
		unless @key_type === key
			raise Literal::TypeError.expected(key, to_be_a: @key_type)
		end

		unless @value_type === value
			raise Literal::TypeError.expected(value, to_be_a: @value_type)
		end

		@mutex.synchronize do
			@hash.delete(key)
			@hash[key] = value

			@hash.shift if @hash.size > @max_size
		end
	end

	def delete(key)
		@mutex.synchronize do
			@hash.delete(key)
		end
	end

	def include?(key)
		@hash.include?(key)
	end

	def compute_if_absent(key)
		@mutex.synchronize do
			if @hash.include?(key)
				@hash[key]
			else
				@hash[key] = yield
			end
		end
	end

	def size
		@hash.size
	end

	def empty?
		@hash.empty?
	end

	def clear
		@hash.clear
	end
end
