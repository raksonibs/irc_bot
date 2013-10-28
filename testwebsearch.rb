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
klass="String"
begin
	doc=Nokogiri::HTML(open("http://ruby-doc.org/core-2.0.0/#{klass}.html"))
rescue OpenURI::HTTPError => e 
	if e.message =="404 Not Found"
		doc=Nokogiri::HTML(open('http://ruby-doc.org/core-2.0.0/String.html'))
	else
		raise e
	end
end

#puts doc
puts doc.css("div#upto-method p")[0]
#p doc.xpath(/title).text

#if source.match(word)
    #puts "Found #{word}"
#end