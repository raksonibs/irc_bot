=begin

import urllib2, re
word = "How to ask"
source = urllib2.urlopen("http://stackoverflow.com").read()
if re.search(word,source):
     print "Found it "+word


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

puts doc.css("div#upto-method p")[0]
=end

require "socket"
require 'nokogiri'
require 'net/http'
require 'open-uri'

class SearchBot

    def respond(msg)
      puts msg
      paragraph=getdocument(msg)
      puts paragraph
      puts "PRIVMSG dog :#{paragraph}" if paragraph
    end

    #word in document
    def getdocument(msg)
      val=msg.split(" ")
      klass=val[0].capitalize
      begin
        doc=Nokogiri::HTML(open("http://ruby-doc.org/core-2.0.0/#{klass}.html"))
        #puts doc
      rescue OpenURI::HTTPError => e 
        if e.message =="404 Not Found"
          #until @server.eof? do
            #respond @server.gets.downcase
          #end
          puts "try again"
       else
          raise e
        end
      end
      value=val[1]+"-method"
      wordindoc?(doc,val)
      answer=doc.css("div\##{value} p")[0]
      answer
    end

    def wordindoc?(doc, val)
      val=val[1]+"-method"

      doc.css("div\##{val} p")[0]
    end
end

bot= SearchBot.new()
val=gets.chomp
bot.respond(val)





#puts doc

#p doc.xpath(/title).text

#if source.match(word)
    #puts "Found #{word}"
#end