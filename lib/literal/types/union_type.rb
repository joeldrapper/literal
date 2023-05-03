class Literal::Types::UnionType
  def initialize(*types)
    @types = types
  end

  def inspect
    "Union(#{@types.map(&:inspect).join(", ")})"
  end

  def ===(value)
    @types.any? { |type| type === value }
  end
end
