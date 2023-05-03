class Literal::Types::TupleType
  def initialize(*types)
    @types = types
  end

  def inspect
    "Tuple(#{@types.map(&:inspect).join(", ")})"
  end

  def ===(value)
    value.is_a?(::Enumerable) && value.size == @types.size && value.zip(@types).all? { |value, type| type === value }
  end
end
