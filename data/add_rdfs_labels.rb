#!/usr/bin/ruby -w

# Copy skos:prefLabel values into rdfs:label
# Write result to original file, keeping a backup of original file

infile = ARGV[0]
bak = File.basename(infile, ".*") + ".bak.rdf"

s = ''
File.open(infile) do |f|
  s = f.read
  open(bak, 'w') { |b| b.puts s }
  s.gsub!(/((^\s*)<skos:prefLabel([^>]+)>(.+)<\/skos:prefLabel>)/, "\\1\n\\2<rdfs:label\\3>\\4</rdfs:label>")
end
File.open(infile, 'w') { |f| f.puts s}

