# frozen_string_literal: true

# @api private
class Literal::ConcurrentHash
	def initialize
		@hash = {}
		@mutex = Mutex.new
	end

	def [](key)
		@hash[key]
	end

	def []=(key, value)
		@mutex.synchronize { @hash[key] = value }
	end

	def each_value(&)
		@hash.each_value(&)
	end
end
