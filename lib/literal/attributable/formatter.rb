# frozen_string_literal: true

class Literal::Attributable::Formatter < Literal::Formatter
	# TODO: Replace this with a test.
	module AbstractNodeMethods
		extend Literal::Modifiers::Abstract

		Literal::Attributable::Nodes.nodes.each do |node|
			abstract node
		end
	end

	include AbstractNodeMethods

	def Access(node)
		visit node.collection
		text "["
		visit node.key
		text "]"
	end

	def Assignment(node)
		visit node.left
		text " = "
		visit node.right
	end

	def AssignSchema(node)
		text "@literal_attributes = self.class.literal_attributes"
	end

	def AttributeCoercion(node)
		text "#{node.attribute.name} = @literal_attributes[:#{node.attribute.name}].coercion.call(#{node.attribute.name})"
	end

	def BlockParam(node)
		text "&#{node.attribute.name}"
	end

	def Def(node)
		text "#{node.visibility} " if node.visibility
		text "def #{node.name}"
		if node.params&.any?
			text "("
			visit_each(node.params) { text ", " }
			text ")"
		end

		indent do
			visit_each(node.body) { newline; newline }
		end

		newline
		text "end"
		newline
	end

	def DefaultAssignment(node)
		text "if Literal::Null == #{node.attribute.escaped}"

		indent do
			text "#{node.attribute.escaped} = @literal_attributes[:#{node.attribute.name}].default_value"
		end

		newline
		text "end"
	end

	def HashLiteral(node)
		text "{"

		indent do
			visit_each(node.mappings) { text ","; newline }
		end

		newline

		text "}"
	end

	def InitializerCallback(node)
		comment "Callback for your own setup logic"
		text "after_initialization if respond_to?(:after_initialization)"
	end

	def KeywordEscape(node)
		text "#{node.attribute.escaped} = binding.local_variable_get(:#{node.attribute.name})"
	end

	def KeywordParam(node)
		if node.attribute.default?
			text "#{node.attribute.name}: Literal::Null"
		elsif node.attribute.type === nil
			text "#{node.attribute.name}: nil"
		else
			text "#{node.attribute.name}:"
		end
	end

	def KeywordSplat(node)
		text "**#{node.attribute.name}"
	end

	def Mapping(node)
		visit node.left
		text " => "
		visit node.right
	end

	def PositionalParam(node)
		if node.default
			text "#{node.name} = #{node.default}"
		else
			text node.name
		end
	end

	def PositionalSplat(node)
		text "*#{node.attribute.name}"
	end

	def Ref(node)
		text node.name
	end

	def Section(node)
		comment node.name if node.name
		visit_each(node.body) { newline; newline } if node.body
	end

	def Symbol(node)
		text ":#{node.name}"
	end

	def TypeCheck(node)
		text "unless @literal_attributes[:#{node.attribute_name}].type === #{node.variable_name}"

		indent do
			text "raise Literal::TypeError.expected(#{node.variable_name}, to_be_a: @literal_attributes[:#{node.attribute_name}].type)"
		end

		newline
		text "end"
	end
end
