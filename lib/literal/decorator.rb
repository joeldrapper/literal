# frozen_string_literal: true

class Literal::Decorator < BasicObject
	extend ::Literal::Attributes

	def method_missing(method, ...)
		@__object__.public_send(method, ...)
	end

	def respond_to_missing?(method, include_private = false)
		@__object__.respond_to?(method, include_private)
	end

	def __getobj__
		@__object__
	end

	def __setobj__(object)
		@__object__ = object
	end

	# TODO: these are currently required by Literal::Attributes, but Literal::Attributes should be updated to be compatible with BasicObject.
	define_method :class, ::Object.instance_method(:class)
	define_method :raise, ::Object.instance_method(:raise)

	private :raise
end
