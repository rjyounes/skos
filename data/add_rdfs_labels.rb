#!/usr/bin/ruby -w

# Copy skos:prefLabel values into rdfs:label
# Write result to original file, keeping a backup of original file

infile = ARGV[0]
bak = File.basename(infile, ".*") + ".bak.rdf"

s = ''
File.open(infile) { |f| s = f.read }
File.open(bak, 'w') { |b| b.puts s }
rdfsns = 'xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"'
s.sub!(/(<rdf:RDF)/, "\\1\n    #{rdfsns}") unless s.include? rdfsns
s.gsub!(/((^\s*)<skos:prefLabel([^>]+)>(.+)<\/skos:prefLabel>)/, "\\1\n\\2<rdfs:label\\3>\\4</rdfs:label>")
File.open(infile, 'w') { |f| f.puts s}

