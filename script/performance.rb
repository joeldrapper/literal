#!/usr/bin/env ruby
# frozen_string_literal: true

require "thor"
require "benchmark/ips"
require "stackprof"
require "singed"
require "memory_profiler"
require "git"

require_relative "../lib/literal"

Singed.output_directory = "./tmp"

require_relative "benchmarks/setup"

class Performance < Thor
	class << self
		def group(name, &block)
			@groups ||= {}
			@groups[name] ||= { name:, reports: [] }
			@current_group = @groups[name]
			instance_eval(&block)
		end

		attr_reader :groups

		def report(name, &block)
			@current_group[:reports] << { name:, tests: [] }
			instance_eval(&block)
		end

		def baseline(name, &block)
			@current_group[:reports].last[:tests] << { name:, block:, baseline: true }
		end

		def test(name, &block)
			@current_group[:reports].last[:tests] << { name:, block: }
		end

		def exit_on_failure? = true
	end

	class_option :runtime, enum: ["both", "yjit", "mri"], default: "mri", desc: "Run with and/or without YJIT enabled"
	class_option :compare_with, type: :string, desc: "Name of branch to compare with results on current branch"

	# TODO: implement assert option
	# class_option :assert, type: :boolean, desc: "Assert that the results are within a certain threshold coded in the tests"

	desc "list [GROUP]", "List all tests in a group"
	def list(group = nil)
		run_pref_test(group) { list_group(_1) }
	end

	desc "ips [GROUP] [REPORT] [TEST]", "Run IPS benchmarks"
	def ips(group = nil, report = nil, test = nil)
		say "Running IPS for #{[group, report, test].compact.join("/")}..."
		say_configuration
		run_pref_test(group) { run_ips(_1, report, test) }
	end

	desc "memory [GROUP] [REPORT] [TEST]", "Run memory profiling"
	def memory(group = nil, report = nil, test = nil)
		say "Running memory profiling for #{[group, report, test].compact.join("/")}..."
		say_configuration
		run_pref_test(group) { run_memory(_1, report, test) }
	end

	desc "flamegraph GROUP REPORT TEST", "Run flamegraph profiling"
	def flamegraph(group, report, test)
		say "> Creating flamegraph for #{[group, report, test].join("/")}..."
		say_configuration
		run_group(group) { run_flamegraph(_1, report, test) }
	end

	# TODO: also YJIT stats output?
	desc "profile [GROUP] [REPORT] [TEST]", "Run CPU profiling"
	option :iterations, type: :numeric, default: 1_000_000, desc: "Number of iterations to run the test"
	def profile(group = nil, report = nil, test = nil)
		say "Run profiling of #{[group, report, test].compact.join("/")}..."
		say_configuration
		run_group(group) { run_profiling(_1, report, test) }
	end

	private

	def say_configuration
		say
		say "Running on branch '#{git_client.current_branch}'"
		say
		say "With #{options[:compare_with] ? "compare with branch: '#{options[:compare_with]}', and " : ''}Runtime: #{options[:runtime].upcase} and assertions: #{options[:assert] || 'skip'}"
		say
	end

	def run_pref_test(group, &)
		if group
			run_group(group, &)
		else
			run_groups(&)
		end
	end

	def run_groups(&)
		self.class.groups.keys.each do |group_name|
			run_group(group_name, &)
		end
	end

	def run_group(group_name)
		group = self.class.groups[group_name]
		raise "Group not found" unless group
		yield group
	end

	def list_group(group)
		say "Group: #{group[:name]}"
		group[:reports].each do |report|
			say "  Report: #{report[:name]}"
			report[:tests].each do |test|
				say "    Test: #{test[:name]}"
			end
		end
	end

	def run_ips(group, report_name, test_name)
		say "> IPS for #{group[:name]}...", :cyan

		execute_report(group, report_name) do |report, runtime|
			Benchmark.ips(time: 3, warmup: 1) do |bm|
				execute_tests(report, test_name) do |test, _|
					test_label = "[#{runtime}] #{test[:baseline] ? "-" : "*"} #{test[:name]}"
					bm.item(test_label, &test[:block])
				end

				# TODO: implement save!

				bm.compare!
			end
		end
	end

	def run_memory(group, report_name, test_name)
		say "> Memory profiling for #{group[:name]}...", :cyan
		execute_report(group, report_name) do |report, runtime|
			execute_tests(report, test_name) do |test, _|
				MemoryProfiler.report do
					test[:block].call
				end.pretty_print
			end
		end
	end

	def run_flamegraph(group, report_name, test_name)
		execute_report(group, report_name)  do |report, runtime|
			execute_tests(report, test_name) do |test, _|
				label = "report-#{group[:name]}-#{report[:name]}-#{test[:name]}".gsub(/[^A-Za-z0-9_\-]/, "_")
				generate_flamegraph(label) do
					test[:block].call
				end
			end
		end
	end

	def run_profiling(group, report_name, test_name)
		say "> Profiling for #{group[:name]} (iterations: #{options[:iterations]})...", :cyan
		execute_report(group, report_name) do |report, runtime|
			execute_tests(report, test_name) do |test, iterations|
				data = StackProf.run(mode: :cpu, interval: 100) do
					# run iterations times
					i = 0
					while i < iterations
						test[:block].call
						i += 1
					end
				end
				StackProf::Report.new(data).print_text
			end
		end
	end

	def execute_report(group, report_name, &)
		compare_with = options[:compare_with]
		say
		# run on current branch, then checkout to compare branch and run again
		say "[[[[ git Branch: '#{git_current_branch_name}' ]]]]", :yellow
		execute_on_runtime(group, report_name, &)
		if compare_with
			git_change_branch(compare_with)
			say "[[[[ compare with git Branch: '#{git_current_branch_name}' ]]]]", :yellow
			execute_on_runtime(group, report_name, &)
		end
	end

	def execute_on_runtime(group, report_name, &)
		runtime = options[:runtime]
		say
		if runtime == "both" || runtime == "mri"
			say "[[[[ run with MRI ]]]]", :yellow
			execute_group(group, report_name, "mri", &)
		end
		if runtime == "both" || runtime == "yjit"
			say "[[[[ run with YJIT ]]]]", :yellow
			raise "YJIT not supported" unless defined?(RubyVM::YJIT) && RubyVM::YJIT.respond_to?(:enable)
			RubyVM::YJIT.enable
			execute_group(group, report_name, "yjit", &)
		end
		say
	end

	def execute_group(group, report_name, runtime)
		group[:reports].each do |report|
			if report_name
				next unless report[:name] == report_name
			end
			say
			say ">> Start report on #{runtime}", :magenta
			say "> --------------------------"
			say "> Report: #{report[:name]}"
			say "> --------------------------"
			say
			yield report, runtime
			say "<< End Report", :magenta
		end
	end

	def execute_tests(report, test_name, &)
		iterations = options[:iterations] || 1
		sorted_tests = report[:tests].sort { _1[:baseline] ? -1 : 1 }
		sorted_tests.each do |test|
			if test_name
				next unless test[:name] == test_name
			end
			say "# ***"
			say "# #{test[:baseline] ? "Baseline" : "Test"}: #{test[:name]}", :green
			say "# ***"
			say
			test[:block].call # run once to lazy load etc
			yield test, iterations
			say
			say
		end
	end

	def generate_flamegraph(label = nil, open: true, ignore_gc: false, interval: 1000, &)
		fg = Singed::Flamegraph.new(label: label, ignore_gc: ignore_gc, interval: interval)
		result = fg.record(&)
		fg.save
		fg.open if open
		result
	end

	def git_client
		@_git_client ||= Git.open(__dir__)
	end

	def git_change_branch(branch)
		# TODO: git to checkout branch (and stash first, then pop after)
		git_client.checkout(branch)
	end

	def git_current_branch_name
		git_client.current_branch
	end
end

# TODO: require all benchmarks/ files with glob
# Tests
require_relative "benchmarks/struct"
require_relative "benchmarks/properties"

