# frozen_string_literal: true

extend Literal::Monads

Account = Struct.new(:user)
User = Struct.new(:address)
Address = Struct.new(:street)

account = Account.new(
	User.new(
		Address.new("123 Main")
	)
)
