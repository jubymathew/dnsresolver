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

# Step 1: Filter  the comments (lines starting with #), and empty lines from the zone file.
# Step 2: Build a hash which represents dns_records.
def parse_dns(dns_raw)
  dns_records_data = dns_raw.select { |line| line[0] != "#" && line[0] != "\n"}

  #Iterate over each line, split it into an array with 3 columns using the .split method,
  dns_records_data.each_with_index{ |line, index|
    line_split= line.split(", ")
    line_split[2] = line_split[2].strip # to remove newline
    dns_records_data[index] = line_split
  }

  dns_hash = {}
  dns_records_data.each{ |line|
    dns_hash[line[1]] = {type: line[0], target: line[2]}
  }
  dns_hash
end

# Step 3 : Resolve DNS value usingrecursion
def resolve(dns_records_hash, lookup_chain_data, domain_data)

  record = dns_records_hash[domain_data]
  if (!record)
    lookup_chain_data << "Error: Record not found for "+ domain_data
  elsif record[:type] == "CNAME"
    lookup_chain_data.push(record[:target])
    resolve(dns_records_hash, lookup_chain_data, record[:target])
  elsif record[:type] == "A"
    lookup_chain_data.push(record[:target])
    return lookup_chain_data
  else
    lookup_chain_data << "Invalid record type for "+ domain_data
    return
  end
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.

dns_records_hash = parse_dns(dns_raw)
#puts dns_records_hash

lookup_chain = [domain]
lookup_chain = resolve(dns_records_hash, lookup_chain, domain)
#puts lookup_chain
puts lookup_chain.join(" => ")
