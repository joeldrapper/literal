# frozen_string_literal: true

extend Literal::Monads

Account = Struct.new(:user)
User = Struct.new(:address)
Address = Struct.new(:street)
