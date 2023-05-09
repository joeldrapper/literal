class Literal::Switch
	def initialize(*required_cases, &block)
		@required_cases = required_cases
		@handled_cases = {}

		yield self

		freeze

		ensure_no_excess_cases
		ensure_no_missing_cases
	end

	def on(*conditions, &block)
		conditions.each do |condition|
			@handled_cases[condition] = block
		end
	end

	def to_proc
		method(:call).to_proc
	end

	def call(value, ...)
		self[value].call(...)
	end

	def [](value)
		@handled_cases.each do |condition, block|
			return block if condition === value
		end
	end

	private

	def ensure_no_excess_cases
		if excess_cases.any?
			raise ArgumentError, "Excess case(s): #{excess_cases.join(', ')}."
		end
	end

	def ensure_no_missing_cases
		if missing_cases.any?
			raise ArgumentError, "Missing case(s): #{missing_cases.join(', ')}."
		end
	end

	def excess_cases = @handled_cases.keys - @required_cases
	def missing_cases = @required_cases - @handled_cases.keys
end
