# frozen_string_literal: true

test do
	assert ExampleDataEnum.frozen?
	assert ExampleDataEnum.first.frozen?

	expect(
		ExampleDataEnum.find_by(name: "Connection Error")
	) == ExampleDataEnum.first

	expect(
		ExampleDataEnum.where(name: "Connection Error")
	) == [ExampleDataEnum.first]
end

test "it loads the same instance" do
	dumped = Marshal.dump(ExampleDataEnum.first)
	loaded = Marshal.load(dumped)

	expect(loaded.object_id) == ExampleDataEnum.first.object_id
end

test "it loads a new instance" do
	untracked = ExampleDataEnum.allocate.tap do |instance|
		instance.instance_exec do
			@attributes = { name: "New", message: "New message" }
		end
	end

	dumped = Marshal.dump(untracked)
	loaded = Marshal.load(dumped)

	expect(loaded.object_id) != untracked.object_id
	expect(loaded.name) == "New"
end
