# frozen_string_literal: true

# @api private
class Literal::Visitor
	def visit(node)
		node.accept(self)
	end

	def visit_each(nodes)
		total = nodes.size
		i = 0
		while i < total
			visit(nodes[i])
			i += 1
			yield if i < total
		end
	end
end
