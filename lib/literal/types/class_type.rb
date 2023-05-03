class Literal::Types::ClassType
  def initialize(type)
    @type = type
  end

  def inspect
    "Class(#{@type.name})"
  end

  def ===(value)
    value.is_a?(::Class) && (value == @type || value < @type)
  end
end
