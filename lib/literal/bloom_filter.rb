# frozen_string_literal: true

require "base64"

class Literal::BloomFilter
	def initialize(size:, hash_count:, bit_array: Array.new(size, false))
		@size = size
		@hash_count = hash_count
		@bit_array = bit_array
	end

	class << self
		def create(*items, error_rate: 0.01)
			bloom_filter = optimized_for(item_count: items.size, error_rate:)
			items.each { |item| bloom_filter.insert(item) }
			bloom_filter.deep_freeze
		end

		def optimized_for(item_count:, error_rate:)
			size = calculate_size(item_count, error_rate)
			hash_count = calculate_hash_count(size, item_count)
			new(size:, hash_count:)
		end

		def calculate_size(item_count, error_rate)
			(-item_count * Math.log(error_rate) / (Math.log(2)**2)).ceil
		end

		def calculate_hash_count(size, item_count)
			(size / item_count.to_f * Math.log(2)).ceil
		end

		def deserialize(string)
			# Decode from Base64
			decoded = Base64.strict_decode64(string)

			# Extract the first 8 bytes (two 32-bit integers) for the header
			header = decoded[0...8]
			size, hash_count = header.unpack("N*")

			# Extract the remaining part for the bit array
			packed_bitstring = decoded[8..]

			# Unpack the bitstring and convert it back to a boolean array
			bitstring = packed_bitstring.unpack1("B*")
			bit_array = bitstring.chars.map { |char| char == "1" }

			# Reconstruct the Bloom filter object
			new(size:, hash_count:, bit_array:)
		end
	end

	def insert(item)
		hash_indices(item).each { |i| @bit_array[i] = true }
	end

	def contains?(item)
		hash_indices(item).all? { |i| @bit_array[i] }
	end

	def serialize
		# Convert @size and @hash_count to 32-bit unsigned integers in network byte order
		header = [@size, @hash_count].pack("N*")

		# Convert the bit array to a string of '0's and '1's
		bitstring = @bit_array.map { |bit| bit ? "1" : "0" }.join

		# Pack the bitstring as a binary string
		packed_bitstring = [bitstring].pack("B*")

		# Combine the header and the packed bitstring
		combined = header + packed_bitstring

		# Encode the combined string in Base64
		Base64.strict_encode64(combined)
	end

	def deep_freeze
		@bit_array.freeze
		freeze
	end

	private def hash_indices(item)
		(0...@hash_count).map do |i|
			[item, i].hash.abs % @size
		end
	end
end
