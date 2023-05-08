# Literal [WIP]

This gem is designed to be a simple alternative to [`Dry::Types`](https://dry-rb.org/gems/dry-types/1.2/), [`Dry::Initializer`](https://dry-rb.org/gems/dry-initializer/3.0/), [`Dry::Struct`](https://dry-rb.org/gems/dry-struct/1.0/), and [`Dry::Struct::Value`](https://dry-rb.org/gems/dry-struct/1.0/#value). It has a lightweight API that works with the case equality operator `===`, which gets you a ton of stuff for free.

You can use it with plain Ruby types — like `String`, `Integer`, `Proc` — and if you need more power, there are advanced type matchers such as `_Array`, `_Union`, `_Maybe`, and `_Interface`.

### What’s the point?

While I’m very excited about [RBS](https://github.com/ruby/rbs) and [Steep](https://github.com/soutaro/steep), I think we’ve still got a long way to go before they can be used in many applications. They will need significant adoption by libraries before we can really use them in our apps.

In the meantime, I think you can get a long way by adding lightweight type checking to public interfaces — initializers and attribute writers: models, operations, jobs, components, etc. That’s where Literals comes in.

### What about performance?

The performance impact of most of the types is negligible: a single case equality check against the given type.

Some of the advanced collection types, such as `_Array` and `_Hash` could be pretty bad for performance, since they need to check every value at runtime. The idea here is to disable these type checks in production, though I must confess, haven’t built the switch for that just yet.

## `Literal::Attributes`

The first tool we provide is the `Literal::Attributes` mixin. It allows you to define type-checked attribute accessors. By default, writers are private and readers are not defined. It also provides a default initializer which assigns all the keyword arguments to the corresponding attributes. This is done through the attribute writers, so the types are checked.

Here we have a user class with a name and an age. The name is a `String` and the age is between 18 and infinity.

```ruby
class User
  extend Literal::Attributes

  attribute :name, String
  attribute :age, 18..
end
```

If we try to pass an invalid value to the initializer, we’ll get an error. Under the hood, the attributes are being assigned to instance variables by the same name. Internally, we can reference these instance variables directly:

```ruby
def first_name = @name.split(/\s/).first
```

The type-checking is really designed for the public interface. Internally, I think it’s good practice to reference the instance variables directly. You can always use the writers (which are private by default) if you need to do type-checking but that’s not usually necessary. We’re not trying to make the application type safe. We can’t do that without a complete type system. What we’re doing is adding some helpful checks to the main public interfaces.

## `Literal::Struct`

Literal structs are similar to Ruby structs, but they have type-checked writers. Readers and writers are public by default. You can use them like this:

```ruby
class Address < Literal::Struct
  attribute :street, String
  attribute :city, String
  attribute :state, String
end
```

## `Literal::Data`
`Literal::Data` is a deeply frozen `Literal::Struct`, which is similar to a Ruby `Data` object. All unfrozen values given to a `Literal::Data` initializer will be duplicated and frozen.

```ruby
class Measure < Literal::Data
  attribute :amount, Float
  attribute :unit, Symbol
end
```

## `Literal::Value`

`Literal::Value` is like a `Literal::Data`, but specifically designed to enrich a single value. You could wrap a `String` as an `EmailAddress` or an `Integer` as a `UserId`.

```ruby
EmailAddress = Literal::Value(String)
UserID = Literal::Value(Integer)
```

We can create a new `UserID` like this:

```ruby
user_id = UserID.new(123)
```

The input will be type-checked. If it's not frozen already, it will be duplicated and frozen.

You can access the value by calling `value` on the object:

```ruby
user_id.value # => 123
```

Because these value types are defined with an underlying type — in this case, `Integer` — the value objects also implement specific coercion methods. With an `Integer` value, you can call `to_i` to get the underlying value:

```ruby
user_id.to_i # => 123
```

With the `EmailAddress`, we could call `to_s` or `to_str`.

These value objects are designed to help you add extra type safety to your application. Let's say we have an operation that sends an email to a user. We could define the operation like this.

```ruby
class EmailUser
  include Literal::Attributes

  attribute :user_id, UserID

  def call
    # ...
  end
end
```

Now, if we try to call the operation with an `Integer` that isn't a `UserID`, we get a type error.

## `Literal::Enum`

[Coming soon]

## `Literal::Operation`

[Coming soon]

## `Literal::Result`

[Coming soon]

## `Literal::Maybe`

[Coming soon]

## `Literal::Either`

[Coming soon]

## `Literal::Array`

[Coming soon]

## `Literal::Hash`

[Coming soon]

## `Literal::Set`

[Coming soon]

## `Literal::Types`

`Literal::Attributes`, `Literal::Struct`, and `Literal::Data` all extend `Literal::Types`, which provide some advanced types including some generic-like collection types.

These types are implemented as methods that return an object with a `===` method designed to match a value to the specified type. From any context where `Literal::Types` is extended, you can reference them directly.

### `_Union(*T)`

The `_Union` type will match if the value has the type of any of the specified `T` types.

```ruby
attribute :name, _Union(String, Symbol)
```

### `_Any`
The `_Any` type is a union of all types apart from `nil`. It’s not literally implemented like that, but that’s how you can think about it. `_Any` is a way to essentially opt-out of type checking.

```ruby
attribute :thing, _Any
```

To make this argument optional and allow `nil`, you could use use `_Nilable`.

### `_Nilable(T)`

The `_Nilable` type is a union of `nil` and the specified type `T`. It’s literally `_Union(T, nil)`.

```ruby
attribute :thing, _Nilable(_Any)
```

### `_Boolean`

The `_Boolean` type is a union of `true` and `false`. It’s literally `_Union(true, false)`.

```ruby
attribute :published, _Boolean
```

### `_Array(T)`

The `_Array` type will match an Array only if all items in the Array match the given type `T`.

```ruby
attribute :names, _Array(String)
```

### `_Set(T)`

The `_Set` type is like `_Array`, but matches for a `Set` instead of an `Array`.

```ruby
attribute :names, _Set(String)
```

### `_Enumerable(T)`

The `_Enumerable` type is like `_Array`, but for any `Enumerable`.

```ruby
attribute :names, _Enumerable(String)
```

### `_Tuple(*T)`

The `_Tuple` type will match an `Enumerable` that contains the given `T` types in order. It’s important that the length of the `Enumerable` also matches the number of `T` types.

```ruby
attribute :names_and_ages, _Array(_Tuple(String, Integer))
```

### `_Hash(K, V)`

The `_Hash` type will match a `Hash` where all the keys match the given `K` type and all the values match the given `V` type.

```ruby
attribute :dictionary, _Hash(String, String)
```

### `_Interface(*M)`

The `_Interface` type ensures the given value responds to the `M` methods.

Note: there's currently no way to match the arity of the methods. If you have any ideas about how to do this, please open an issue.

```ruby
attribute :name, _Interface(:to_s)
```

### `_Class(T)`

The `_Class` type ensures the given value is a class and subclasses the given `T` class.

```ruby
attribute :error, _Class(RuntimeError)
```

### `_Integer(T)`

While you can use `Integer` to match only integers, the `_Integer` type allows you to limit that type with a more specific type `T`, such as a `Range`. You could use a literal range (e.g. `10..20`) but that would allow for `Float` values. Using `_Integer` ensures the value is an `Integer`.

```ruby
attribute :age, _Integer(18..)
```

### `_Float(T)`

The `_Float` type is the same as `_Integer`, but for `Float` values.

```ruby
attribute :degrees _Float(0..360)
```

You can also compose these types together to form more complex types. You can also save your own types as constants for re-use.

```ruby
AttributeType = Literal::Types::_Union(
  String,
  Symbol,
  Literal::Types::_Interface(:to_s)
)
```

Note unless you've extended `Literal::Types`, you'll need to reference the types by their fully qualified names. These types are methods, so why are we accessing them with `::`? It's a little known fact that `::` can stand in for `.` in Ruby. I like using `::` here becuase it makes these look more like normal generics. If you prefer, you can use `.`, e.g. `Literal::Types._Interface(:to_s)`.

## Writing your own type matchers

Values are compared to types using the type’s `===` operator. When there’s an error, the type’s `inspect` value is shown in the message. That means you can easily define your own type matchers as objects that respond to `===` and `inspect`. It’s worth taking a look at how the [built in](https://github.com/joeldrapper/literal/tree/main/lib/literal/types) type matchers are defined here.

### Procs as types

It just so happens that, Procs alias `===` to `call`, which means you can provide a Proc as a type and it will work as expected. The Proc will be called with the value and should return `true` or `false`.

## Benchmarks

### Class with instance variables

| Normal Ruby Class | `Dry::Initializer` | `Literal::Attributes` |
|---|---|---|
| 5.226M ips | 1.494M ips | 3.399M ips |

### Struct

| Normal Ruby Struct | `Dry::Struct` | `Literal::Struct` |
|---|---|---|
| 4.100M ips | 1.333M ips | 3.029M ips |

### Data

It’s worth noting that while Ruby’s built-in `Data` objects are themselves frozen, they do not freeze the given values. `Dry::Struct::Value` does freeze the given values and `Literal::Data` duplicates and freezes the given values if they’re not already frozen.

| Normal Ruby Data | `Dry::Struct::Value` | `Literal::Data` |
|---|---|---|
| 4.272M ips | 286.696K ips | 2.017M ips |
