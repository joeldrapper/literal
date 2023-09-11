# frozen_string_literal: true

class Literal::Method
	def initialize(name, object_class)
		@name = name
		@object_class = object_class

		@rest = nil
		@keyrest = nil
		@method = nil
		@number_of_required_positional_parameters	= nil
		@number_of_required_keyword_parameters	= nil
		@parameters = nil
	end

	attr_reader :name, :object_class

	def ==(other)
		method == other.method
	end

	def <(other)
		# Match positional arguments
		return false unless rest? || (
			number_of_required_positional_parameters >=
				other.number_of_required_positional_parameters
		)

		# Match keyword arguments
		return false unless keyrest? || (
			number_of_required_keyword_parameters >=
				other.number_of_required_keyword_parameters
		)

		# Match visibility
		case other.visibility
		when :public
			visibility == :public
		when :protected
			visibility == :public || visibility == :protected
		else
			true
		end
	end

	def visibility
		@visibility ||= if object_class.public_instance_methods.include?(name)
			:public
		elsif object_class.protected_instance_methods.include?(name)
			:protected
		else
			:private
		end
	end

	def rest?
		@rest ||= parameters.include?(:rest)
	end

	def keyrest?
		@keyrest ||= parameters.include?(:keyrest)
	end

	def method
		@method ||= @object_class.instance_method(@name)
	end

	def number_of_required_positional_parameters
		@number_of_required_positional_parameters ||= parameters.count(:req)
	end

	def number_of_required_keyword_parameters
		@number_of_required_keyword_parameters ||= parameters.count(:keyreq)
	end

	def parameters
		@parameters ||= method.parameters.map(&:first)
	end
end
