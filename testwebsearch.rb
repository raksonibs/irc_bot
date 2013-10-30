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
      puts paragraph unless paragraph==nil
      puts "Not an actual Class available or method. Try again!" if paragraph==nil
      #puts "PRIVMSG dog :#{paragraph}" if paragraph
    end

    #word in document
    def getdocument(msg)
      val=msg.split(" ")
      klass=val[0].capitalize
      begin
        doc=Nokogiri::HTML(open("http://ruby-doc.org/core-2.0.0/#{klass}.html"))
      rescue OpenURI::HTTPError => e 
        if e.message =="404 Not Found"
          puts "try again"
       else
          raise e
        end
      end
      p val[1][-1]
      unless val[1][-1]=="!" || val[1][-1]=="?"
        value=val[1]+"-method" unless val[1]==nil
        answer=doc.css("div\##{value} p")[0] unless doc==nil
      elsif val[1][-1]=="|"
        value=val[1][/\w+/i] unless val[1]==nil
        regexp=val[1][-1].unpack("H*")[0].upcase
      else
        value=val[1][/\w+/i] unless val[1]==nil
        regexp=val[1][-1].unpack("H*")[0].upcase
        value=value+"-#{regexp}"+"-method" unless val[1]==nil
        answer=doc.css("div\##{value} p")[0] unless doc==nil
      end
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