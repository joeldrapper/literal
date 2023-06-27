# frozen_string_literal: true

test do
	original = ExampleStruct.new(name: "example")
	packed = Marshal.dump(original)
	unpacked = Marshal.load(packed)

	expect(unpacked) == original
end
