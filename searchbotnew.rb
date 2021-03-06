#my bot will look for some sort of helpful code in the the api docks of ruby
#and spit it out

require "socket"
require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'debugger'

class SearchBot

  def initialize(server = nil)
    @nick = "SearchBot"
    @channel = "#bitmaker"
    @serverconnect = server
    @port=6667
    @greeting_prefix = "privmsg #bitmaker :"
    @match=false
  end
  #xml near match look at->
  def start
    @server=TCPSocket.open(@serverconnect,@port)
    @server.puts "USER bhellobot 0 * BHelloBot"
    @server.puts "NICK #{@nick}"
    @server.puts "JOIN #{@channel}"
    @server.puts "PRIVMSG #{@channel} :Hello from SearchRubyDoc Bot"
    @server.puts "PRIVMSG #{@channel} :Type the class you want to search out of Hash, String, Array, or Enumerable, followed by the method For example, String upto:"

    until @server.eof? do
      respond @server.gets
    end
  end

    def respond(msg)
      puts msg
  
      paragraph=getdocument(msg)
      para=paragraph.text.gsub("\n", " ") unless paragraph==nil

      if (paragraph)
        @server.puts "PRIVMSG #{@channel} :#{para}" 
        @match= true
      #else
        #@server.puts "PRIVMSG #{@channel} :Not an actual Class available or method. Try again!"
      end
      #@server.puts "PRIVMSG #{@channel} :Sorry didn't work!" if !paragraph
    end

    #word in document
    def getdocument(msg)
      #refactor to if msg.match(/Hash|String|Enumerable|Array/i)
        if (msg.match(/Hash/i) || msg.match(/String/i) || msg.match(/Enumerable/i) || msg.match(/Array/i) )

        
          val=msg.split(" ")
          klass=val[-2].to_s.capitalize.gsub(":", "").capitalize
          doc=Nokogiri::HTML(open("http://ruby-doc.org/core-2.0.0/#{klass}.html"))
          begin
             doc=Nokogiri::HTML(open("http://ruby-doc.org/core-2.0.0/#{klass}.html"))
          rescue OpenURI::HTTPError => e 
              if e.message =="404 Not Found"
                @server.puts "PRIVMSG #{@channel} :Error in typing."
              else
                raise e
             end
          end

        unless val[-1][-1]=="!" || val[-1][-1]=="?" || val[-1][-1]=="|"

          value=val[-1].downcase+"-method" unless val[1]==nil
          answer=doc.css("div\##{value} p")[0] unless doc==nil
        else

          value=val[-1][/\w+/i] unless val[1]==nil


          regexp=val[-1][-1].unpack("H*")[0].upcase

          value=value+"-#{regexp}"+"-method" unless val[1]==nil

          answer=doc.css("div\##{value} p")[0] unless doc==nil
          

        end
        puts answer
        answer


          #value=((val[-1]).downcase)+"-method"


          #answer=doc.css("div\##{value} p")[0]
          #answer

      end
      
    end

    def wordindoc?(doc, val)
      val=val[1]+"-method"
      doc.css("div\##{val} p")[0]
    end
end

bot= SearchBot.new("moorcock.freenode.net")
bot.start

