#
#
# run_ips("Literal::Properties - .new") do |x|
# 	# x.report "Ruby Class" do
# 	# 	NormalClass.new(first_name: "Joel", last_name: "Drapper", age: 29)
# 	# end
#
# 	x.report "Dry::Initializer" do
# 		DryClass.new(first_name: "Joel", last_name: "Drapper", age: 29)
# 	end
#
# 	x.report "Literal::Properties" do
# 		LiteralClass.new(first_name: "Joel", last_name: "Drapper", age: 29)
# 	end
#
# 	x.save! "literal_bench_out_new.json"
# 	x.compare!
# end

Performance.group "Properties" do
	first_name = "Joel"
	last_name = "Drapper"
	age = 29

	report ".new" do
		baseline "Ruby" do
			NormalClass.new(first_name:, last_name:, age:)
		end

		baseline "Dry" do
			DryClass.new(first_name:, last_name:, age:)
		end

		test "Literal" do
			LiteralClass.new(first_name:, last_name:, age:)
		end
	end
end
