# frozen_string_literal: true

#  @api private
class Literal::Method
	def initialize(name, object_class)
		@name = name
		@object_class = object_class

		@method = @object_class.instance_method(@name)
		@parameters = @method.parameters.map(&:first)

		@rest = @parameters.include?(:rest)
		@keyrest = @parameters.include?(:keyrest)

		@number_of_required_positional_parameters	= @parameters.count(:req)
		@number_of_optional_positional_parameters	= @parameters.count(:opt)

		@number_of_required_keyword_parameters = @parameters.count(:keyreq)
		@number_of_optional_keyword_parameters = @parameters.count(:key)

		@visibility = if @object_class.public_instance_methods.include?(name)
			:public
		elsif @object_class.protected_instance_methods.include?(name)
			:protected
		else
			:private
		end
	end

	attr_reader :name,
		:object_class,
		:method,
		:parameters,
		:rest,
		:keyrest,
		:number_of_required_positional_parameters,
		:number_of_optional_positional_parameters,
		:number_of_required_keyword_parameters,
		:number_of_optional_keyword_parameters,
		:visibility

	alias_method :rest?, :rest
	alias_method :keyrest?, :keyrest

	def ==(other)
		@method == other.method
	end

	def <(other)
		self != other &&
			positional_parameters_match?(other) &&
				keyword_parameters_match?(other) &&
					visibility_match?(other)
	end

	def number_of_positional_parameters
		@number_of_required_positional_parameters + @number_of_optional_positional_parameters
	end

	def number_of_keyword_parameters
		@number_of_required_keyword_parameters + @number_of_optional_keyword_parameters
	end

	private

	def positional_parameters_match?(other)
		number_of_required_positional_parameters <= other.number_of_required_positional_parameters && (
			rest? || (!other.rest? && (
				number_of_positional_parameters >= other.number_of_positional_parameters
			))
		)
	end

	def keyword_parameters_match?(other)
		number_of_required_keyword_parameters <= other.number_of_required_keyword_parameters && (
			keyrest? || (!other.keyrest? && (
				number_of_keyword_parameters >= other.number_of_keyword_parameters
			))
		)
	end

	def visibility_match?(other)
		case other.visibility
		when :public
			visibility == :public
		when :protected
			visibility == :public || visibility == :protected
		else
			true
		end
	end
end
