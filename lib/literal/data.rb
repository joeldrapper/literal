class Literal::Data < Literal::Struct
  def initialize(...)
    super
    @attributes.each(&:freeze)
    @attributes.freeze
    freeze
  end

  def dup(**attributes)
    self.class.new(**@attributes.merge(attributes))
  end
end
