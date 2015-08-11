#!/usr/bin/ruby -w

# Copy skos:prefLabel values into rdfs:label
# Write result to original file, keeping a backup of original file

infile = ARGV[0]
bak = File.basename(infile, ".*") + ".bak.rdf"

s = ''
File.open(infile) { |f| s = f.read }
File.open(bak, 'w') { |b| b.puts s }

# The rdfs:label manipulations may be useful to other data sets, perhaps using a 
# different property from skos:prefLabel
rdfsns = 'xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"'
s.sub!(/(<rdf:RDF)/, "\\1\n    #{rdfsns}") unless s.include? rdfsns
s.gsub!(/((^\s*)<skos:prefLabel([^>]+)>(.+)<\/skos:prefLabel>)/, "\\1\n\\2<rdfs:label\\3>\\4</rdfs:label>")

# This may be specific to the NYTimes dataset
s.gsub!(/(<owl:sameAs[^>]+\/(owl:sameAs)?>)/, "<!-- \\1 -->")

# Remove rdf document individuals
s.gsub!(/<rdf:Description rdf:about="[^>]+\.rdf">.+?<\/rdf:Description>/m, '')

# Add the ConceptScheme individual that all Concepts in the dataset are part of.
# This addition is specific to the NYTimes dataset
nytd_des = 'rdf:Description rdf:about="http://data.nytimes.com/elements/nytd_des"' 
nytd_des_descr = <<eos
  <#{nytd_des}>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
    <skos:prefLabel xml:lang="en">New York Times Subject Descriptors</skos:prefLabel>
    <rdfs:label xml:lang="en">New York Times Subject Descriptors</rdfs:label>
  </rdf:Description>
eos
s.gsub!(/(<\/rdf:RDF>)/, "#{nytd_des_descr}\\1") unless s.include? nytd_des

File.open(infile, 'w') { |f| f.puts s}

