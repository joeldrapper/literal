# frozen_string_literal: true

module Literal::Attributable::Nodes
	@nodes = Concurrent::Array.new
	self.class.attr_reader :nodes

	def self.node(name, *attributes)
		@nodes << name

		node_class = Data.define(*attributes) do
			class_eval <<~RUBY, __FILE__, __LINE__ + 1
				def accept(visitor)
					visitor.#{name}(self)
				end
			RUBY
		end

		const_set(name, node_class)
	end

	node :Access, :collection, :key
	node :Assignment, :left, :right
	node :AssignSchema
	node :AttributeCoercion, :attribute
	node :BlockParam, :attribute
	node :Def, :visibility, :name, :params, :body
	node :DefaultAssignment, :attribute
	node :HashLiteral, :mappings
	node :InitializerCallback
	node :KeywordEscape, :attribute
	node :KeywordParam, :attribute
	node :KeywordSplat, :attribute
	node :Mapping, :left, :right
	node :PositionalParam, :name, :default
	node :PositionalSplat, :attribute
	node :Ref, :name
	node :Section, :name, :body
	node :Symbol, :name
	node :TypeCheck, :attribute_name, :variable_name
end
