class Literal::ConcurrentArray
	def initialize
		@value = []
		@mutex = Mutex.new
	end

	def <<(value)
		@mutex.synchronize { @value << value }
	end

	def each(&)
		@value.each(&)
	end

	def concat(other)
		@mutex.synchronize { @value.concat(other.value) }
	end

	protected def value = @value
end
