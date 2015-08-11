#!/usr/bin/ruby -w

# Copy skos:prefLabel values into rdfs:label
# Write result to original file, keeping a backup of original file

infile = ARGV[0]
bak = File.basename(infile, ".*") + ".bak.ttl"

s = ''
File.open(infile) { |f| s = f.read }
File.open(bak, 'w') { |b| b.puts s }

# The rdfs:label manipulations may be useful to other data sets, perhaps using a 
# different property from skos:prefLabel
s.gsub!(/((^\s*)skos:prefLabel(.*@en;))/, "\\1\n\\2rdfs:label\\3")


File.open(infile, 'w') { |f| f.puts s}

