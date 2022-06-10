# frozen_string_literal: true

# 1. Write a function that sorts the keys in a hash by the length of the key as a string.
# For instance, the hash:
#  { abc: 'hello', 'another_key' => 123, 4567 => 'third' }
# -> ["abc", "4567", "another_key"]

input_hash = { abc: 'hello', 'another_key' => 123, 4567 => 'third' }
def hash_keys_to_sorted_arr(input_hash)
  # input_hash.keys.sort { |a, b| a.to_s.length <=> b.to_s.length }
  # input_hash.keys.sort_by { |key| key.to_s.length }
  input_hash.keys.map { |key| key.to_s }.sort_by(&:length)
end

puts "1. Results: #{hash_keys_to_sorted_arr(input_hash)}"

# 2. Write a single line of ruby code that prints the Fibonacci sequence of any length as an array
# Hint: use inject/reduce
