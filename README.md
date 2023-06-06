# Literal [WIP]

While I’m very excited about [RBS](https://github.com/ruby/rbs) and [Steep](https://github.com/soutaro/steep), they will need significant adoption by libraries before we can really use them in our apps.

In the meantime, I think you can get a long way by adding lightweight type checking to your main public interfaces (initializers and writer methods) for models, operations, jobs, components, etc.

Literal provides a few tools to help you define type-checked structs, data objects and value objects, as well as a mixin for your plain old Ruby objects.

### What about performance?

Literal uses code generation at startup, rather than dynamic meta-programming, so the performance of a literal initializer, is equivalent to one you’d write by hand. The performance impact of most of the type-checking is negligible: a single case equality check against the given type.

Some of the advanced types, such as `_Array` and `_Hash` could have a significant performance impact for large collections, since they need to check every value at runtime. But you can disable expensive type-checking in production, while benefitting from using it in test and development environments.

## `Literal::Struct`

Literal structs are similar to Ruby structs, but they have type-checked writers and initializers.

You can define a literal struct by subclassing `Literal::Struct` and calling the `attribute` macro for each attribute. The first argument is the *name* of the attribute, which must be a `Symbol`. The second argument is the *type*, which must respond to `===`.

```ruby
class Address < Literal::Struct
  attribute :house_number, Integer
  attribute :street, String
end
```

You can optionally pass `reader:` and `writer:` keyword arguments set to `:public`, `:protected`, `:private` or `false`.

Literal structs have public readers and writers by default.

## `Literal::Data`
`Literal::Data`  is similar to a Ruby `Data` object. It is frozen and, therefore, immutable. Unlike a `Literal::Struct`, it has no writers.

Additionally, all unfrozen values given to a `Literal::Data` initializer will be duplicated and frozen for extra safety. You can define a `Literal::Data` object much the same as a `Literal::Struct`, but the `attribute` macro doesn’t accept the `writer:` argument.

```ruby
class Measure < Literal::Data
  attribute :amount, Float
  attribute :unit, Symbol
end
```

Just like a Ruby `Data` object, you can make a copy of a `Literal::Data` object with specific changes using `#with`.

## `Literal::Value`

`Literal::Value` is like a `Literal::Data`, but specifically designed to enrich a single value — you could wrap a `String` as an `EmailAddress` or an `Integer` as a `UserId`.

We can define literal value classes like this:

```ruby
EmailAddress = Literal::Value(String)
UserID = Literal::Value(Integer)
```

We could use this `UserID` class like this:

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

## `Literal::Attributes`

The `Literal::Attributes` mixin allows you to define type-checked attribute accessors on your plain old Ruby objects using the same `attribute` macro.

By default, writers are private and readers are not defined. It also provides a default initializer which assigns all the keyword arguments to the corresponding attributes.

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

The type-checking is really designed for the public interface. Internally, I think it’s good practice to reference the instance variables directly. You can always use the writers (which are private by default) if you need to do type-checking, but that’s not usually necessary. We’re not trying to make the application type-safe. We can’t do that without a complete type system. What we’re doing is adding some helpful checks to the main public interfaces.

## `Literal::Enum`

[Coming soon]

## `Literal::Operation`

[Coming soon]

## `Literal::Result`

[Coming soon]

## `Literal::Maybe`

[Coming soon]

You can create a `Literal::Maybe` with `Literal::Maybe(Integer).new(1)`. This will return a `Literal::Some`. If you created it with `nil` instead, it would return a `Literal::Nothing`. `Literal::Some`s and `Literal::Nothing` both implement the same interface.

#### `map`

When called on a `Literal::Some`, yields the value to the block and returns its result wrapped in a `Literal::Some`. When called on `Literal::Nothing`, returns `self`. Note: it's possible to end up with a `Literal::Some(nil)` when using `map`. To avoid this, use `maybe` instead.

#### `maybe`

Like `map` but if the result of the block is `nil`, returns `Literal::Nothing` instead.

Example:

```ruby
account = Maybe(Account).new(get_account)
account.maybe(&:user).maybe(&:address).maybe(&:street).value_or { "No Street Address" }
```

#### `bind`

Like `map` but expects the block to return a `Literal::Maybe` (either a `Literal::Some` or `Literal::Nothing`).

#### `filter`

When called on `Literal::Some`, yields the value to the block and if the block returns truthy, returns self. Otherwise, returns `Literal::Nothing`. When called on `Literal::Nothing`, returns self.

#### `value_or`

When called on a `Literal::Some`, returns the underlying value. When called on `Literal::Nothing` yields the block.

## `Literal::Either`

`Literal::Either(String, Integer).new("Hello")` will return a `Literal::Left`, while `Literal::Either(String, Integer).new(1)` will return a `Literal::Right`.

If we call `left` on a `Literal::Right`, we'll get `Literal::Nothing`. However, if we call `right` on the `Literal::Right`, we'll get `Some(Integer)`.

[Coming soon]

## `Literal::Array`

[Coming soon]

## `Literal::Hash`

[Coming soon]

## `Literal::Set`

[Coming soon]

## `Literal::Switch`

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

Note unless you've extended `Literal::Types`, you'll need to reference the types by their fully qualified names. These types are methods, so why are we accessing them with `::`? It's a little known fact that `::` can stand in for `.` in Ruby. I like using `::` here because it makes these look more like normal generics. If you prefer, you can use `.`, e.g. `Literal::Types._Interface(:to_s)`.

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
