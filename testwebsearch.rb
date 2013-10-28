=begin

import urllib2, re
word = "How to ask"
source = urllib2.urlopen("http://stackoverflow.com").read()
if re.search(word,source):
     print "Found it "+word

=end

require 'nokogiri'
require 'net/http'
require 'open-uri'

#source = Net::HTTP.get(URI.parse('http://ruby-doc.org/core-2.0.0/String.html'))


doc=Nokogiri::HTML(open('http://ruby-doc.org/core-2.0.0/String.html'))
#puts doc
puts doc.css("div#upto-method p")[0]
#p doc.xpath(/title).text

#if source.match(word)
    #puts "Found #{word}"
#end