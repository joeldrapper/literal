# frozen_string_literal: true

extend Literal::Monads

User = Struct.new(:name, :address)
Address = Struct.new(:street, :city, :state, :zip)

user = User.new("Bob", Address.new("123 Main", "Anytown", "CA", "12345"))

binding.irb
