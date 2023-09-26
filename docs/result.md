# Literal::Result

`Literal::Result` is an interface representing the result of an operation that may fail. It is either:
1. an instance of `Literal::Success` containing a value, or
2. an instance of `Literal::Failure` containing an error.

Both success and failure classes implement the same interface and from the outside you can treat them the same. Until we know the result of the operation, we don't know which one we have. It's kind of like shroedinger's cat.

```ruby
def download_cat
	Literal::Result(Cat).try do
		fetch_cat_from_api
	end
end
```

When we call `download_cat`, we could have a `Literal::Success(Cat)` or a `Literal::Failure(Exception)`. We don't know until we try to open the box.

## Opening the box

Since the box could be a failure, we'll need to open it carefully.

### `value_or`

The easiest way to open the box is to call `value_or`. This method must be passed a block which is yielded the error if the box is a failure. If the box is a success, the block is not called and the value is returned.

```ruby
download_cat.value_or do |error|
	# handle error
end
```

### pattern matching

Another option is to use pattern matching to open the box.

```ruby
case download_cat
in Literal::Success(Cat) => cat
	# do something with cat
in Literal::Failure(message:) => error
	# handle error
end
```

## Inspecting the box

If you want to know if the box is a success or a failure without opening it, you can use the `success?` and `failure?` methods.

## Before opening the box

### `map`

You can think of the result box like an Array. It might be an empty Array, or it could contain a Cat. In either case, you can use `map` to transform the contents of the box.

If the box is a failure, the map does nothing and simply returns itself. However, if the box is a success, the map yields the value to the block and returns the result wrapped in a new success box.

In order to not lose track of what might be in the box, you need to provide a new type for the box contents when mapping.

```ruby
download_cat.map(String) { |cat| cat.name }
```

Now instead of having a `Result(Cat)` — which means either a `Success(Cat)` or a `Failure(Exception)` — we have a `Result(String)` which means either a `Success(String)` or a `Failure(Exception)`.

We can chain as many mappings as we want without worrying if there's anything in the box.

### `then`

What if the `Cat` object doesn't have a name, but instead fetches it with another API call? In this case, the `name` method might return a `Result(String)` rather than a `String` since this operation could fail.

```ruby
class Cat
	def name
		Literal::Result(String).try do
			fetch_name_from_api(self)
		end
	end
end
```

Then we'd have a `Result(Result(String))` which means either a `Success(Success(String))` or a `Success(Failure(Exception))` or a `Failure(Exception)`. That's a lot of boxes!

In this case, we can use `then` instead of `map`. `then` must return a `Result(T)` where `T` is the type of the value in the box (is case, that's a `String`)

```ruby
download_cat.then(String, &:name)
```

Note, we're using `&:name` which is exactly the same as a block that calls `name` on the first argument (`{ |cat| cat.name }`). This is just a shorthand.

Now we have a `Result(String)` which is much easier to work with.

## Other stuff

Sometimes you'll want to raise the error in the box. Here are a few ways to do that:

### `value_or_raise!`

This is like `value_or` but it raises the error instead of yielding it to a block. Essentially the same as `value_or { |error| raise(error) }`.

```ruby
cat = download_cat.value_or_raise!
```

### `raise!`

If you're not interested in the success value, you can just call `raise!` that raises if the result is a failure, otherwise does nothing.

## Handling specific failures

Sometimes you'll want to handle specific failures but otherwise raise. In fact, you may want to ensure that some other piece of code handles specific errors.

Let's revisit the `download_cat` method again:

```ruby
def download_cat
	Literal::Result(Cat).try do
		fetch_cat_from_api
	end.handle!(HTTP::Error)
end
```

Now, if the failure is anything other than an `HTTP::Error`, it will be raised. Otherwise, it just returns the result object, which must be either:

1. a `Success(Cat)`, or
2. a `Failure(HTTP::Error)`

Going further, we can pass a block to `handle!` which will be yielded a special `Result::Case` object. This is easier to show in code.

First lets update the `download_cat` method to take a block and pass it on to the `handle!` method:

```ruby
def download_cat(&)
	Literal::Result(Cat).try do
		fetch_cat_from_api
	end.handle!(HTTP::Error, &)
end
```

Now we can call it like this

```ruby
download_cat do |r|
	r.on_success { |cat| do_something_with(cat) }
	r.on_failure(HTTP::Error) { |error| handle_http_error(error) }
end
```

This looks a lot like a case statment or the pattern matching syntax we saw earlier, but the difference is it's exhaustive. The block must handle the success case and all failure cases specified in the `download_cat` method.
