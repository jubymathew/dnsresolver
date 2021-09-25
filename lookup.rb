def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")


# A hash that uses symbol as keys...
symbol_key_hash = { :type => 'A', :target => 'gmail.com' }

# ...and a hash that uses strings as keys:
string_key_hash = { 'type' => 'A', 'target' => 'gmail.com' }
symbol_key_hash == string_key_hash
# => false
# A hash that uses symbols as keys, using the "old" Ruby notation...
traditional_hash = { :type => 'A', :target => 'gmail.com' }

# And the same hash, but using the "new" notation for writing hashes that use symbols as keys...
# Note how this format is shorter and easier to write.
modern_key_hash = { type: 'A', target: 'gmail.com' }
traditional_hash == modern_key_hash
# => true




# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")